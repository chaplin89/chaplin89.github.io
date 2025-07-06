**Important note**: This is mostly made for myself as I wanted these information in a single page and in an easily accessible place. Don't take it as the bible. I'm not a pro (by no means).

## Properties
The main properties of the soldering wire are:
1. **Melting temperature**. Sometimes lower is better, sometimes higher is better.
2. **Is an eutectic alloy?** Does it melt at a specific, single temperature or it has a so called "plastic range"? You most definitely want the first in when working with electronic.
3. **Does it have lead?** Lead is toxic if you ingest it, which can happen by mistake even if you're not Ralph Wiggum.
4. **Wettability/Flow**. How easy it "sticks" to the thing you want to solder?
5. **Strenght**. how easy it is to break the joint under mechanical or thermal fatigue?
6. **How big is the wire?** Bigger wires are used on bigger joints. More thermal mass, more heat required to melt.
7. **What chemical components are inside?** Each of them bring unique properties to the alloy. Alloys are usually expressed with their chemical element followed by the percentage. Sn63/Pb37 means 63% of Tin (Sn) and 37% of Lead (Pb).
8. **Core**. The core of the wire may or may not contain flux, which usually make soldering easier.

## Elements
As said, each element introduce unique properties and the same elements mixed in different ratios can also create alloys with different properties.
 Rather than learning the individual properties of each alloy, is important to understand the general properties of each elements to be able to orient yourself when buying a soldering wire. These are the most common elements.
1. **Sn: Tin**. The primary component. The "glue" to create bonds. 232C melting point.
2. **Pb: Lead**. Lower the melting temperature (e.g., 183C for Sn63/Pb37) and increase strength. Health and environmental risks.
3. **Ag: Silver**. Lower the melting temperature, increase strength, wettability. Often mixed with Cu (so-called SAC alloys). Expensive.
4. **Cu: Copper**. Help preserving the copper from the PCB and the iron tip. Very cheap. Brittle if used alone with Sn.
5. **Bi: Bismuth**. Significantly lower the melting point (e.g., 138C for Sn42/Bi58). Excellent for heat-sensitive components. Very brittle. Not to be used as an alternetive of lead, expecially to prepare a pad for wicking. Even for small amounts of Bi, when it's mixed with other alloys it can melt at dangerously low temperatures (even 96C for leaded alloys).
6. **Sb: Antimony**. Increase strength and slightly improve the wettability.
7. **In: Indium**. For extremely low temperatures. Increase strength. Expensive.
6. **Zn: Zinc**. Lower melting temperature (e.g., 199C for eutectic Sn-Zn alloy). Can bond very well to Aluminum. Require special flux.

## Most common alloys

As mentioned, there are a lot of possibilities when it comes to alloy. The following are the most common one. This is by no means a comprehensive list. Some websites list more than 50 alloys.

| Alloy (Composition) | Melting Temp. | Eutectic? | Ease of Work (1-5, 5=easiest) | Strength (1-5, 5=strongest) | Costs (relative) | Other Peculiar Properties / Disadvantages |
| :------------------ | :------------ | :-------- | :---------------------------- | :-------------------------- | :--------------- | :---------------------------------------- |
| Sn63/Pb37 | $183^\circ C$ | Yes | **5** - Melts/solidifies sharply, excellent flow & wettability, shiny joints. Very forgiving. | **4** - Very good strength, ductility, and fatigue resistance for general use. | Low | **Contains lead (toxic, regulated).** Excellent for general electronics, reliable. Suppresses tin whiskers. |
| SAC305 (Sn96.5/Ag3.0/Cu0.5) | $217^\circ C - 221^\circ C$ | Near-Eutectic | **3** - Higher melting point requires more heat. Joints can be dull/grainy, harder to visually inspect. Flow is good but less "forgiving" than leaded. | **4** - Good strength, creep resistance, and thermal fatigue resistance. Strongest common lead-free. | Medium-High | Most common lead-free. Silver content improves strength & wettability. More brittle than leaded. |
| Sn99.3/Cu0.7 | $227^\circ C$ | Yes | **3** - Higher melting point. Joints can be dull. Good flow but slightly less robust wetting than SAC. Can be aggressive on copper tips. | **3** - Good strength, but generally less robust thermal fatigue resistance than SAC. | Low | Cost-effective lead-free. Can be aggressive on copper features if soldering parameters aren't optimized. |
| Sn42/Bi58 (e.g., Sn42/Bi50/Cu8) | $138^\circ C$ | Yes ($138^\circ C$ for Sn42/Bi58) | **3** - Very low melting point is easy on sensitive components. Requires lower iron temps. | **2** - **Highly brittle.** Very poor mechanical shock and thermal fatigue resistance. | Medium | **Ultra-low melting point.** **Critically risky to mix with leaded solder (forms $~96^\circ C$ alloy) or other lead-free solders (forms lower-melt, brittle alloys).** Not for high-reliability/vibration. |
| Sn91/Zn9 | $199^\circ C$ | Yes | **2** - Prone to heavy oxidation/dross in air. Requires aggressive fluxes. Can be challenging to get good flow. | **3** - Good strength but prone to corrosion in humid environments. | Low | **Excellent for soldering aluminum.** Poor oxidation resistance (requires N2 or strong flux). Prone to corrosion. |
