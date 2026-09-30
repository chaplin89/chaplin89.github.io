---
layout: post
title: Solder wire cheatsheet
comments: true
---

* TOC
{:toc}

**Important note**: I made this mostly for myself, because I wanted all this information on a single page that's easy to reach. Don't take it as the bible: I'm by no means a pro.

## Properties
The main properties of a solder wire are:
1. **Melting temperature**. Sometimes lower is better, sometimes higher is better.
2. **Is it a eutectic alloy?** Does it melt at a single, sharp temperature, or does it have a so-called "plastic" (or "pasty") range where it is half solid and half liquid? For hand soldering electronics you generally want the former: a joint that is moved while it's still in the plastic range can end up cracked or grainy ("cold").
3. **Does it contain lead?** Lead is toxic if you ingest it, which can happen by mistake even if you're not Ralph Wiggum. Wash your hands after soldering and don't eat at the bench. The smoke you see comes from the flux, not the lead (lead doesn't evaporate at soldering temperatures), but it's still irritating, so use a fume extractor.
4. **Wettability/Flow**. How easily does it flow onto and bond with the surfaces you're soldering?
5. **Strength**. How easily does the joint break under mechanical stress or thermal fatigue?
6. **Wire diameter**. Thicker wire is for bigger joints; thinner wire gives you more control on small pads. A bigger joint has more thermal mass and needs more heat.
7. **Composition**. Each element brings its own properties to the alloy. Alloys are usually written as each chemical element followed by its percentage: Sn63/Pb37 means 63% tin (Sn) and 37% lead (Pb).
8. **Core**. The core of the wire may or may not contain flux, which cleans the surfaces and makes soldering much easier. Common types are rosin, no-clean and water-soluble.

## Elements
As said, each element brings its own properties, and the same elements mixed in different ratios can produce alloys with different properties.
Rather than memorizing every alloy, it's more useful to understand what each element does, so you can find your way around when buying solder wire. These are the most common elements:
1. **Sn: Tin**. The main component, the "glue" that forms the bond. Melts at 232°C.
2. **Pb: Lead**. Lowers the melting temperature (e.g., 183°C for Sn63/Pb37), improves wetting and ductility, and suppresses tin whiskers. Health and environmental risks.
3. **Ag: Silver**. Lowers the melting temperature and improves strength and wettability. Often combined with Cu (the so-called SAC alloys: Sn-Ag-Cu). Expensive.
4. **Cu: Copper**. Reduces the dissolution of copper from PCB pads and iron tips. Very cheap. Too much of it forms brittle intermetallic compounds.
5. **Bi: Bismuth**. Significantly lowers the melting point (e.g., 138°C for Sn42/Bi58). Excellent for heat-sensitive components. Very brittle. Don't use it as a replacement for leaded solder when you "dilute" a lead-free joint before wicking: any Bi left on the pad contaminates the next joint. Even small amounts of Bi mixed with other alloys can melt at dangerously low temperatures (as low as ~96°C with leaded alloys).
6. **Sb: Antimony**. Increases strength and creep resistance. Mostly found in high-reliability and high-temperature alloys.
7. **In: Indium**. For very low melting temperatures (e.g., 118°C for In52/Sn48). Very ductile, with good thermal fatigue resistance. Wets glass and ceramics. Expensive.
8. **Zn: Zinc**. Lowers the melting temperature (e.g., 199°C for the eutectic Sn91/Zn9). Mostly useful for aluminium. Oxidizes very easily and requires special flux.

## Most common alloys

As mentioned, there are a lot of possible alloys. The following are the most common ones. This is by no means a comprehensive list: some websites list more than 50 alloys.

| Alloy (Composition) | Melting Temp. | Eutectic? | Ease of Work (1-5, 5=easiest) | Strength (1-5, 5=strongest) | Cost (relative) | Other Peculiar Properties / Disadvantages |
| :------------------ | :------------ | :-------- | :---------------------------- | :-------------------------- | :--------------- | :---------------------------------------- |
| Sn63/Pb37 | 183°C | Yes | **5** - Melts/solidifies sharply, excellent flow & wettability, shiny joints. Very forgiving. | **4** - Very good strength, ductility, and fatigue resistance for general use. | Low | **Contains lead (toxic, regulated).** Excellent for general electronics, reliable. Suppresses tin whiskers. |
| Sn60/Pb40 | 183°C - 190°C | No | **4** - Like Sn63/Pb37, but the small plastic range makes it slightly less forgiving if the joint moves while cooling. | **4** - Practically the same as Sn63/Pb37. | Low | **Contains lead (toxic, regulated).** Very common in hobby shops. If you can choose, get Sn63/Pb37 instead. |
| SAC305 (Sn96.5/Ag3.0/Cu0.5) | 217°C - 220°C | Near-eutectic | **3** - Higher melting point requires more heat. Joints can be dull/grainy, harder to visually inspect. Flow is good but less "forgiving" than leaded. | **4** - Good strength, creep resistance, and thermal fatigue resistance. Strongest common lead-free. | Medium-High | Most common lead-free. Silver content improves strength & wettability. More brittle than leaded. |
| Sn99.3/Cu0.7 | 227°C | Yes | **3** - Higher melting point. Joints can be dull. Good flow but slightly less robust wetting than SAC. | **3** - Good strength, but generally less robust thermal fatigue resistance than SAC. | Low | Cost-effective lead-free. Like all high-tin alloys, wears out iron tips faster. Nickel-doped variants (e.g., SN100C) give shinier joints. |
| Sn42/Bi58 (or Sn42/Bi57.6/Ag0.4) | 138°C | Yes | **3** - Very low melting point is easy on sensitive components. Requires lower iron temps. | **2** - **Highly brittle.** Very poor mechanical shock and thermal fatigue resistance. The small silver addition helps a bit. | Medium | **Ultra-low melting point.** **Critically risky to mix with leaded solder (forms a ~96°C alloy) or other lead-free solders (forms lower-melt, brittle alloys).** Not for high-reliability/vibration. |
| Sn91/Zn9 | 199°C | Yes | **2** - Prone to heavy oxidation/dross in air. Requires aggressive fluxes. Can be challenging to get good flow. | **3** - Good strength but prone to corrosion in humid environments. | Low | **Excellent for soldering aluminium.** Poor oxidation resistance (requires N2 or strong flux). Prone to corrosion. |
