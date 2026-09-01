# Ask someone you trust to check this

*Written for people who are not scientists. Every claim links to the page where it is proved, and every number can be checked by anyone with a laptop and an afternoon. That is the whole point.*

---

## The short version

There is a measurable amount of vaporised spacecraft in the air above you right now.

Not predicted. Measured. In February and March of 2023, a NASA high-altitude aircraft flew out of Fairbanks, Alaska, and sampled the stratosphere with an instrument that analyses individual particles one at a time. It looked at more than five hundred thousand of them.

**About one in ten of the larger particles up there now contains aluminium and other metals from satellites that burned up on re-entry.**

That is a published, peer-reviewed measurement. The people who made it wrote that within a few decades, that fraction could reach **half** — and then wrote, in the same paper, that the effect of that on the atmosphere **is unknown**.

They are not being coy. Nobody knows.

---

## Why "nobody knows" is the alarming part

You would expect that a thing being deliberately put into the upper atmosphere, in growing quantities, by companies with names you recognise, would be measured. Someone would be required to weigh it, sample it, report it.

**No one is.**

We searched the rules — the American communications regulator, the aviation regulator, the international treaty bodies, national space laws. There is exactly one reporting duty attached to satellites burning up in the atmosphere, and it reads, in full:

> *"The number of satellites that re-entered the atmosphere."*

A count. Twice a year. Not the mass. Not what they were made of. Not what altitude they burned at. Just how many.

It gets narrower. Under the law, a satellite designed to burn up **is not legally a re-entering vehicle at all** — that term is reserved for things meant to come back in one piece. So the rules that would normally trigger an environmental review never apply. When the aviation regulator wrote its report to Congress on exactly this subject, the words *ozone*, *stratosphere*, and *air quality* **do not appear in it once**. Its entire concern was whether debris might land on someone.

And the direction of travel is toward less. There is a live proposal to exempt space operations from environmental review altogether, on the reasoning that they happen outside anyone's territory. There is another to waive thirteen environmental laws for launch companies — **including the Clean Air Act**.

---

## What is actually happening, in numbers you can check

One company went from **nothing in 2019 to 45.8% of all the mass entering Earth's atmosphere in 2025.** Not 45.8% of satellites — 45.8% of the total mass, human-made and natural, coming down.

The aluminium specifically: the researchers who measured the particles also compared the sources. Meteors — the natural background, the thing that has been falling since before there were people — deliver about **20 tonnes** of vaporising aluminium to the upper atmosphere each year.

Spacecraft now deliver about **210 tonnes.**

*(Honest caveat, and we put it on the page: that natural figure is disputed. Other researchers, some of them co-authors on the same papers, put it up to seven times higher, which would make the ratio much smaller. Nobody has settled it. That unsettledness is itself part of the problem.)*

And there is now an application before the American regulator for a constellation of **one million satellites** to run data centres in orbit. By the applicant's own filing, about forty thousand of them would burn up in the atmosphere every year, forever, as they are replaced.

---

## What we are *not* saying

We are not saying this will end the world. We are not saying anyone will die. We are not saying the ozone layer is collapsing — in fact a 2025 paper in *Nature* found the ozone layer is **recovering**, and we link to it.

Five research groups have modelled what this material does up there. **They disagree about whether the effect is positive or negative.** One found a *weaker* ozone hole. One found a slight *increase* in ozone. One found the damage comes from a different chemical entirely.

We could have written a frightening number here. We deliberately did not, and we published our reasons — including a calculation of our own that we ran, checked, and **threw out** because one of its inputs turned out to be wrong.

**We are saying something narrower and, we think, worse:**

> The forcing is growing, it is exactly countable, it is already detectable in the sky — and we have arranged things so that no one is obliged to find out what it does.

You cannot fix what you have decided not to measure. And the decisions being made right now — the exemptions, the waivers, the reporting rule that asks only for a count — are decisions to *keep* not measuring, while the quantity goes up.

---

## Why this is a question about children specifically

Not because anyone is in danger tomorrow. Because of how the timescales stack.

Material put into the stratosphere stays for **one to four years** before it settles out. A satellite constellation is planned in **decades**. The regulatory exemptions being proposed now would last until someone repeals them. And an atmospheric change, if there is one, would be visible in the data long after the thing causing it became normal, funded, and structurally difficult to stop.

The window in which measuring is cheap and stopping is possible is **now**. It closes quietly, without anyone announcing it, simply by everyone deciding this is somebody else's department.

That is the ordinary way large irreversible things happen. Not by decision. By nobody's decision.

---

## What to actually do

**Send this to one person who can check it.** An atmospheric scientist. A chemist. A physicist. A graduate student. Someone who reads papers for a living and will enjoy trying to prove it wrong.

Ask them to check four things:

1. **Murphy et al. 2023**, *PNAS* 120(43) e2313374120 — is it really 10% of stratospheric particles, and does the paper really say 210 tonnes of spacecraft aluminium against 20 tonnes meteoric?
2. **The five modelling papers** — do they really disagree on the sign? *(Ferreira 2024, Maloney 2025, Revell 2025, Barker 2026, Vliex 2026 — all cited on [the evidence page](Reentry-Forcing-Nobody-Measures.md).)*
3. **The reporting rule** — is the only re-entry duty really just a count of satellites?
4. **Our arithmetic** — clone the repository, run one script, see whether every number reproduces.

```
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch && bash reproduce/validate.sh
```

No account. No key. No permission needed from us. The script checks that every published figure appears in the output of the program that produces it, and it is designed to **fail loudly** if we have got something wrong. It has caught us three times.

**If they find an error, tell us.** Corrections go on the page with the mistake named. There are several there already, including one where we published a number five times too large and said so.

**And if it holds up, ask them the only question that matters:**

> *Why is no one required to measure this?*

That question does not depend on who is right about the ozone. It gets stronger the more the scientists disagree — because disagreement is the argument for measuring, not for waiting.

---

## The ask, in one line

**Not "stop the satellites." Just: weigh what comes down, say what it was made of, and don't repeal the only rules that could ever require it.**

Report mass and material instead of a count. Fund the aircraft instrument that already produced the measurement. Do not exempt this from environmental review while the question is open. Publish an agreed figure for the natural background so the ratios can be settled.

None of that requires deciding who is right. All of it requires someone deciding to look.

---

*Full evidence, every citation, and every number we withdrew: **[The reentry forcing nobody is required to measure](Reentry-Forcing-Nobody-Measures.md)**.*
