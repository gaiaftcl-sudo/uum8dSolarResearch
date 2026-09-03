// The GPU screen: loads the CHECKED-IN metallib by URL. It never compiles a
// shader at launch — makeLibrary(source:) costs 300–2000 ms and would break the
// no-slow-start requirement; makeLibrary(URL:) costs 1–3 ms. If the metallib is
// missing or the device is unavailable, this REFUSES and the caller falls back
// to the CPU golden path — never a silent wrong answer.
import Foundation
import Metal
import FusionLaw

public enum GPUStatus: Sendable, Equatable {
    case ready
    case unavailable(String)
}

public final class VerdictScreenGPU: @unchecked Sendable {
    private let device: MTLDevice
    private let queue: MTLCommandQueue
    private let pipeline: MTLComputePipelineState
    public let status: GPUStatus = .ready

    public init?() {
        guard let dev = MTLCreateSystemDefaultDevice(),
              let q = dev.makeCommandQueue() else { return nil }
        guard let url = Bundle.module.url(forResource: "verdict_screen", withExtension: "metallib"),
              let lib = try? dev.makeLibrary(URL: url),
              let fn = lib.makeFunction(name: "verdict_screen"),
              let pipe = try? dev.makeComputePipelineState(function: fn) else { return nil }
        self.device = dev; self.queue = q; self.pipeline = pipe
    }

    /// Compute the terminal ordinal per agent on the GPU. `windows` is a flat
    /// row-major [Int16] of agentCount * windowLen. Returns one UInt32 per agent.
    public func screen(windows: [Int16], windowLen: Int, agentCount: Int) -> [UInt32]? {
        guard windows.count == windowLen * agentCount, agentCount > 0 else { return nil }
        let inBytes = windows.count * MemoryLayout<Int16>.stride
        guard let inBuf = device.makeBuffer(bytes: windows, length: inBytes, options: .storageModeShared),
              let outBuf = device.makeBuffer(length: agentCount * MemoryLayout<UInt32>.stride,
                                             options: .storageModeShared) else { return nil }
        var wl = UInt32(windowLen), ac = UInt32(agentCount)
        guard let cb = queue.makeCommandBuffer(), let enc = cb.makeComputeCommandEncoder() else { return nil }
        enc.setComputePipelineState(pipeline)
        enc.setBuffer(inBuf, offset: 0, index: 0)
        enc.setBytes(&wl, length: 4, index: 1)
        enc.setBytes(&ac, length: 4, index: 2)
        enc.setBuffer(outBuf, offset: 0, index: 3)
        let tg = min(pipeline.maxTotalThreadsPerThreadgroup, 256)
        enc.dispatchThreads(MTLSize(width: agentCount, height: 1, depth: 1),
                            threadsPerThreadgroup: MTLSize(width: tg, height: 1, depth: 1))
        enc.endEncoding(); cb.commit(); cb.waitUntilCompleted()
        let p = outBuf.contents().bindMemory(to: UInt32.self, capacity: agentCount)
        return Array(UnsafeBufferPointer(start: p, count: agentCount))
    }
}

/// The CPU golden, one agent at a time, from the ONE law. This is the truth the
/// GPU must match bit-for-bit.
public enum CPUGolden {
    public static func terminalOrdinal(_ w: ArraySlice<Int16>) -> UInt32 {
        let arr = w.map { Int32($0) }
        switch arr.withUnsafeBufferPointer({ FusionLaw.screen($0).verdict }) {
        case .NOMINAL: return 0
        case .MITIGATE: return 1
        case .REFUSED_OUT_OF_ENVELOPE: return 2
        case .REFUSED_MALFORMED: return 3
        }
    }
}
