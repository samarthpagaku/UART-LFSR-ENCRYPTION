# UART-LFSR Encryption

This project is a UART communication system written in Verilog with an added hardware-based encryption layer using Linear Feedback Shift Registers (LFSRs).

I first built a basic UART transmitter and receiver and then extended the design by adding lightweight encryption. Instead of using a fixed encryption key, the transmitter and receiver each use an identical LFSR to generate synchronized pseudo-random keys. The transmitted data is encrypted before transmission and decrypted at the receiver using the same key sequence.

The goal of this project was to understand UART communication while exploring how simple hardware security techniques can be integrated into digital designs.

---

## Features

- UART Transmitter and Receiver
- Baud Rate Generator
- 8-bit LFSR-based Dynamic Key Generation
- XOR-based Encryption and Decryption
- Independent synchronized LFSRs for the transmitter and receiver
- RTL Simulation using Icarus Verilog
- Waveform verification using GTKWave
- Logic synthesis using Yosys and the Nangate45 Open Cell Library

---

## Project Structure

```
rtl/
│── uart.v
│── tx.v
│── rx.v
│── baud_rate.v
│── lfsr.v
│── encryption.v
└── decryption.v

testbench/
└── uart_tb.v

synthesis/
├── uart_synth.v
├── tx_synth.v
├── rx_synth.v
├── lfsr_synth.v
├── encryption_synth.v
├── decryption_synth.v
│
├── uart_stat.png
├── tx_stat.png
├── rx_stat.png
├── lfsr_stat.png
├── encryption_stat.png
└── decryption_stat.png

flowcharts/
waveforms/
images/
```

---

## How It Works

The transmitter generates an encryption key using an 8-bit LFSR. Before transmission, the input data is XORed with this key and sent over UART.

At the receiver, another LFSR is initialized with the same seed and advances in sync with the transmitter. Since both LFSRs generate the same sequence of keys, XORing the received data with the generated key recovers the original message.

The LFSRs are updated only after a complete byte has been transmitted and received, ensuring both sides remain synchronized.

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys
- Nangate45 Open Cell Library

---

## Simulation

Compile:

```bash
iverilog -g2012 -o uart_sim rtl/*.v testbench/uart_tb.v
```

Run:

```bash
vvp uart_sim
```

View waveforms:

```bash
gtkwave uart.vcd
```

---

## Synthesis

All RTL modules (except the testbench) were synthesized using **Yosys** with the **Nangate45 Open Cell Library**.

The repository includes:

- Technology-mapped netlists
- Gate-level statistics
- Cell counts
- Chip area reports

for every RTL module in the design.

---

## Results

The project was successfully simulated and synthesized.

- UART transmission and reception verified
- Dynamic key generation using synchronized LFSRs
- Correct encryption and decryption of transmitted data
- Technology-mapped netlists generated using Nangate45 standard cells
- Gate count and chip area reports generated for all RTL modules

---

## Future Improvements

Some improvements I would like to add in the future include:

- CRC-based error detection
- Parity bit support
- Stronger encryption algorithms (AES or lightweight ciphers)
- FPGA implementation
- UVM/SystemVerilog-based verification

---

## Acknowledgements

This project was developed as a learning exercise to gain hands-on experience with RTL design, digital communication protocols, and the RTL-to-gate synthesis flow using open-source EDA tools.
