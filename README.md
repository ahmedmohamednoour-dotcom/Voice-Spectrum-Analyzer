# Voice Spectrum Analyzer - ECEN313 Signals and Systems Project

## Overview
This repository contains the implementation of the **Voice Spectrum Analyzer** project for the ECEN313 Signals and Systems course. The objective is to create an interactive MATLAB/Octave application that captures or loads a voice signal, processes it, and visualizes it in both the time and frequency domains. Users can input parameters like maximum recording time (Tmax) and sampling frequency, and interact with plots for amplitude, phase, and energy spectra.

Key features:
- Option to upload an existing audio file (.mp3 or .wav) or record live from a microphone.
- Real-time processing and plotting of the voice signal in time domain.
- Frequency domain visualizations: amplitude spectrum, energy spectrum, and phase spectrum.
- Interactive GUI controls for zooming axes in time and frequency plots.
- Hamming window applied for spectral analysis to reduce leakage.

This project was implemented in MATLAB/Octave, fulfilling the course requirements for a graphical user interface (GUI) and spectral display. It supports mono or stereo audio and processes frames in a buffered manner for efficient visualization.

## Requirements
- **MATLAB**  or **Octave** installed.
- Audio Toolbox (for MATLAB) or equivalent packages in Octave for audio recording and reading (e.g., `audiorecorder`, `audioread`).
- No additional installations needed; uses built-in functions.

Tested on:
- Windows/Mac/Linux with MATLAB R2023b.
- Octave 8.4.0.

## Installation
1. Clone the repository:
2. Navigate to the repository folder:
3. Open MATLAB/Octave and run the script `project1.m`.

## Usage
1. Run the script in MATLAB/Octave:
