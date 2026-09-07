# The radio link of an open sensor pod, in exact integer microseconds

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  SPEC_NAME
IDENTITY       LORAWAN-SF12-BW125
SPEC_AUTHORITY LoRa Alliance LoRaWAN regional parameters, spreading factor 12 at 125 kHz bandwidth, with the symbol timing of the Semtech SX1276 datasheet
TITLE          Frame airtime and hourly transmissions under a fixed duty budget
MEASURED       At a 4,096 microsecond symbol and a 36,000,000 microsecond hourly duty budget: a 201-byte floating-point JSON frame takes 233 symbols and 1,004.544 ms, allowing 35 transmissions an hour. A 42-byte frame carrying a 16-byte integer delta and a 26-byte header takes 58 symbols and 287.744 ms, allowing 125. The budget floors and never rounds.
PROGRAM        lora-time-on-air
FIGURE         float JSON frame      201    233      1004.544     35
FIGURE         FRAME: 16B delta + 26B hdr42     58       287.744      125
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/lora-time-on-air.swift — exact integer microseconds throughout, with the 16-byte row as its control
REFUSED        not a built pod and not a bench measurement. These are airtimes computed from published symbol timing, not a radio anyone switched on
REFUSED        not a hardware design, a bill of materials or an assembly route. This entry names the link and what was computed about it
REFUSED        not a claim that the integer frame is sufficient for any application. It is smaller and it is cheaper on air; whether it carries enough is a different question
FALSIFIER      a bench measurement of the same configuration disagreeing with the computed airtime, or a duty-budget count that rounds where the law floors
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 lora-time-on-air.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
