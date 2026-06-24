# UART Transmitter and Receiver in Verilog HDL

## Overview

This project implements a Universal Asynchronous Receiver Transmitter (UART) in Verilog HDL. The design includes a UART Transmitter (TX), UART Receiver (RX), and a Baud Rate Generator. Communication is verified using a loopback testbench where transmitted data is directly connected to the receiver.

The project demonstrates finite state machine (FSM) design, serial communication protocols, synchronous digital design, and RTL verification using simulation.

---

## Features

* UART Transmitter (TX)
* UART Receiver (RX)
* Baud Rate Generator
* FSM-based architecture
* Start bit and stop bit framing
* 8-bit data transmission
* LSB-first serial transmission
* Loopback verification through simulation
* VCD waveform generation for analysis

---

## Project Structure

```text
uart/
│
├── uart_tx.v      // UART transmitter
├── uart_rx.v      // UART receiver
├── baud_gen.v     // Baud rate generator
├── uart_tb.v      // Testbench
├── uart.vcd       // Simulation waveform
└── README.md
```

---

## UART Frame Format

Each transmitted frame consists of:

```text
| Start Bit | 8 Data Bits | Stop Bit |
|     0     |  LSB First  |     1    |
```

Example for transmitting:

```text
0xAA = 10101010
```

UART serial stream:

```text
Start  Data Bits (LSB→MSB)  Stop

  0    0 1 0 1 0 1 0 1      1
```

---

## Module Description

### 1. Baud Rate Generator

Generates a periodic baud tick used to synchronize transmission and reception.

**Inputs**

* `clk`
* `reset`

**Outputs**

* `baud_tick`

---

### 2. UART Transmitter

Implements serial data transmission using a finite state machine.

#### States

```text
IDLE → START → DATA → STOP → IDLE
```

#### Inputs

* `clk`
* `reset`
* `baud_tick`
* `data_in[7:0]`
* `data_ready`

#### Outputs

* `tx_serial`
* `tx_busy`

---

### 3. UART Receiver

Receives serial data and reconstructs the original byte.

#### States

```text
IDLE → DATA → STOP → IDLE
```

#### Inputs

* `clk`
* `reset`
* `baud_tick`
* `rx_serial`

#### Outputs

* `data_out[7:0]`
* `data_valid`

---

## Simulation

The testbench performs loopback communication:

```verilog
assign rx_serial = tx_serial;
```

Test data:

```verilog
data_in = 8'b10101010;
```

Expected result:

```text
Transmitted : 10101010
Received    : 10101010
```

Simulation output:

```text
data_valid = 1
data_out   = 10101010
```

This confirms successful UART transmission and reception.

---

## How to Run

### Compile

```bash
iverilog -o tb_uart.vvp uart_tb.v uart_tx.v uart_rx.v baud_gen.v
```

### Simulate

```bash
vvp tb_uart.vvp
```

### View Waveforms

```bash
gtkwave uart.vcd
```

---

## Concepts Demonstrated

* Finite State Machines (FSMs)
* Serial Communication Protocols
* Verilog RTL Design
* Synchronous Sequential Logic
* Baud Rate Generation
* Digital System Verification
* Testbench Development

---

## Author

Lokesh Kumar

Developed as a digital design project to strengthen Verilog HDL, FSM design, and communication protocol implementation skills.
