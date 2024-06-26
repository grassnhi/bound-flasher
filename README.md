# LSI Logic Design - Bound Flasher

## Lab 1: Logic Design and Verification

### Interface

![interface](Design/interface.png)


#### Description of signals in Bound Flasher:

|     Signal    |     Width    |     In/Out    |     Description                                                                                     |
|---------------|--------------|---------------|-----------------------------------------------------------------------------------------------------|
|     reset     |     1        |     In        |     An   asynchronous (active low) input signal. Reset = 0: System is restarted to Initial State    |
|     clock     |     1        |     In        |     A   positive edge clock signal used to operate state’s   transition.                            |
|     flick     |     1        |     In        |     A   special input for controlling state transfer.                                               |
|     LEDs      |     16       |     Out       |     A   signal representing the state of 16 lamps of the bound flasher.                             |
|     flick     |     1        |     In        |     A   special input for controlling state transfer.                                               |
|     LEDs      |     16       |     Out       |     A   signal representing the state of 16 lamps of the bound flasher.                             |


### Specification

The bound flasher contains 16 lamps which has operation as below:
- At the initial state, all lamps are OFF. If flick signal is ACTIVE (set 1), the flasher start operating:
    1. The lamps are turned ON gradually from lamp[0] to lamp[5].
    2. The lamps are turned OFF gradually from lamp[5] (max) to lamp[0] (min).
    3. The lamps are turned ON gradually from lamp[0] to lamp[10].
    4. The lamps are turned OFF gradually from lamp[10] (max) to lamp[5] (min).
    5. The lamps are turned ON gradually from lamp[5] to lamp[15].
    6. The lamps are turned OFF gradually from lamp[15] to lamp[0].
- Finally, the lamps are turned ON then OFF simultaneously (blink), return to the initial state.
- Additional condition:
    - At each kickback point (lamp[5] and lamp[10]), if flick signal is ACTIVE, the lamps will turn OFF gradually again to the min lamp of the previous state, then continue operation as above description.
    - For simplicity, kickback points are considered only when the lamps are turned ON gradually, except the first state.
Refer to next pages for example of operation.

Below is the demonstration:

![spec1](Design/spec1.png)

![spec2](Design/spec2.png)

### Internal implementation

#### Block diagram
![architecture](Design/architecture.png)

#### Block diagram of Bound Flasher Description: 

|     Name                                    |     Type             |     Description                                                                                                                                                                                                                                                               |
|---------------------------------------------|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     flick                                   |     Input            |     Flick signal (controlling the state transfer)                                                                                                                                                                                                                             |
|     rst                                     |     Input            |     Reset signal                                                                                                                                                                                                                                                              |
|     clk                                     |     Input            |     Clock signal                                                                                                                                                                                                                                                              |
|     next_state                              |     Reg              |     This specifies the next state of the system                                                                                                                                                                                                                               |
|     current_state                           |     Reg              |     This contains the current state of the system                                                                                                                                                                                                                             |
|     LEDsTemp                                |     Reg              |     This specifies the next state of the lamps.                                                                                                                                                                                                                               |
|     LEDs                                    |     Output           |     This contains the values representing the current   state of the lamps.                                                                                                                                                                                                   |
|     “State generation” logic combination    |     Control block    |     The functionality of this block is to determine   the state that the system will be perform next. Its decision is based on the   current state and the current value of some constraints such as kickback   point’s value, the flick and reset signal.                    |
|     “Control led” logic combination         |     Control block    |     The functionality of this block is to perform   certain bitwise operation such as shift left, shift right and or. It uses the   input information of the next state generated and to generate new value for   each leds in the lamps so that the LEDs will be updated.    |
|     D-Flip Flop (1)                         |     D-FF             |     The first D-FF is used to to update the current   state (provided by the “State generation” block) based on the clock edge and   reset event.                                                                                                                             |
|     D-Flip Flop (2)                         |     D-FF             |     The input signal is the LEDTemp which stores   the next value of the LEDs generated by the “Control led” block. This D-FF is   used to update output signals (LEDs) based on the clock edge and reset event.                                                              |
#### State Machine

![fsm](Design/fsm.png)

#### Variable name of State machine:

|     Variable name    |     Description                                                                                                                                                                     |
|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     reset            |     An asynchronous input signal. When reset = 0, the state returns   to      the initial state.                                                                                    |
|     flick            |     At each kickback point (LEDs [5] and LEDs [0]) when the leds are   turned OFF gradually (except final state), if flick signal = 0, the leds go   back and repeat that state.    |
|     led              |     A 16-bits output signal represents 16 lamps. LEDs[0] is the LSB   and      LEDs[15] is the MSB.                                                                                 |

#### State name of State machine:



|     State   |     Description                                                                                                                                                                     |
|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     INIT            |     This is the initial state. Initially, all lamps are OFF. When the flick and the reset are active, the state change to the ON 0 TO 15 state to start operating. Otherwise, if reset is passive, it remains in this state.                                                                                   |
|     ON_0_TO_5            | <ul><li>Reset = 1: If the flick and the reset are active, the lamps are turned on gradually from LEDs [0] to LEDs [5] by “Shift all the bit to the left by 1 and then or with 1”. Whenever LED[5] is on, the system moves to the next state – OFF_5_TO_0.</li><li>Reset = 0: Back to INIT state.</li></ul>|
|     OFF_5_TO_0              |    <ul><li>Reset = 1: The LEDSs are turned off gradually from LEDs [5] to LEDs [0] by “Shift all the bit to the right by 1”. Whenever LED[5] or LEDs[10] is off and flick signal is active, then state changed to ON_0_TO_10</li><li>Reset = 0: Back to INIT state.</li></ul>|
|     ON_0_TO_10            | <ul><li>Reset = 1: The LEDSs are turned on gradually from LEDs [0] to LEDs [10] by “Shift all the bit to the left by 1 and then or with 1”. Whenever LEDs[5] or LED[10] (kickback points) and the flick signal is active, the system go back to turn off gradually again to the min lamp of the previous state state – OFF_5_TO_0. Otherwise, when the flick signal is passive and the LEDs[10] is on, the system move to the next state - OFF_10_TO_5.</li><li>Reset = 0: Back to INIT state.</li></ul>|
|     OFF_10_TO_5              |    <ul><li>Reset = 1: The LEDSs are turned off gradually from LEDs [10] to LEDs [5] by “Shift all the bit to the right by 1”. When LED[5] is off, the state changed to ON_5_TO_15. </li><li>Reset = 0: Back to INIT state.</li></ul>|
|     ON_5_TO_15              |    <ul><li>Reset = 1: The LEDSs are turned on gradually from LEDs [5] to LEDs [15] by “Shift all the bit to the left by 1 and then or with 1”. Whenever LED[15] is on, the system moves to the next state – OFF 15 TO 0. Otherwise, if the LEDs[5] or LEDs[10] are on at the flick sigal 1, the system go back to the previous state - OFF_10_TO_5. </li><li>Reset = 0: Back to INIT state.</li></ul>|
|     OFF_15_TO_0              |    <ul><li>Reset = 1: The LEDSs are turned off gradually from LEDs [5] to LEDs [0] by “Shift all the bit to the right by 1”. Whenever LED[0] is off, the state changed to the BLINK state.</li><li>Reset = 0: Back to INIT state.</li></ul>|
|BLINK| All the leds of the lamp will turn on simultaneously in this state. After performing the operation, the state will be changed to the INIT state.|


## Lab 2: Logic Synthesis

- Synthesis: RTL code -> Netlist
- Generate report

## Lab 3: Logic Equivalence Check (LEC) 

- Logic Equivalence checking between RTL and its Netlist to ensure that the functionality of them are the same.
- Using Cadence tool – Conformal-LEC, which perform LEC.

## Lab 4: Spectre simulation and Layout Design

- The schematics and simulation of INVERTER, AND, and OR gate.
- The layout design, DRC, and LVS reports of the INVERTER gate.