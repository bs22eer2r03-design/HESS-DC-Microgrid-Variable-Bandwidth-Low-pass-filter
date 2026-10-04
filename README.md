
PAPER ID - 10806

TITLE: A Variable Bandwidth Low Pass Filter Approach based Power Sharing and Voltage Regulation in Hybrid Energy Storage Systems for DC Microgrid Applications

Authors:
Bomma Siddhartha, Research Scholar, Department of Electrical Engineering, National Institute of Technology, Warangal, E-mail: bs22eer2r03@student.nitw.ac.in .

Prof. Udaya bhasker Manthati, IEEE member, Associate Professor, Department of Electrical Engineering, National Institute of Technology, Warangal, E-mail: ub@nitw.ac.in .

About Repository:
This repository contains the MATLAB files  used for our paper titled "A Variable Bandwidth Low Pass Filter Approach based Power Sharing and Voltage Regulation in Hybrid Energy Storage Systems for DC Microgrid Applications".

ABSTRACT:
In DC microgrids, battery–supercapacitor-based hybrid
energy storage systems (HESSs) are widely adopted to
compensate for power imbalances between distributed generation
and load variations. Conventional control methods exhibit limited
capability in accurately diverting high-frequency components
within the Supercapacitor (SC) current loop. To overcome this
limitation, this paper proposes a variable-bandwidth scheduling
strategy aimed at improving the SC current tracking performance
in HESS. Unlike traditional designs, the proposed
approach removes the constant low-pass filter from the SC
current loop and varies the bandwidth of the current decomposition
process within the HESS. This paper propose a variable
bandwidth filter for diverting the currents for battery and SC
based on voltage of SC. By applying different bandwidths for
a low pass filter based on the SC voltage, the DC-link voltage
ripple is decreased, and the SC utilization is optimized within the
HESS. Consequently, the error signal to the battery is diverted
to be given to the SC current. Furthermore, the controller gains
are appropriately tuned to ensure stable system response based
on the classical Bode analysis of the resultant transfer function.
The effectiveness of the proposed current diversion is verified
through simulation and experimental results

Description of Files:
The uploaded files include MATLAB scripts used to generate the analytical and simulation results presented in the manuscript. Block diagram files corresponding to the developed models are provided to illustrate the system architecture and control implementation. In addition, simulation output images, hardware images , and OPAL-RT files obtained during experimental validation are included. These materials were used for manuscript preparation and facilitate a clear understanding, reproducibility, and verification of the reported results.

Software Requirements:
MATLAB R2020b or later.
Simulation file Design Specifications:
Simulation parameter Details : Battery-1 Capacity (Eb1) 40 kWh, Battery-2 Capacity (Eb2) 100 kWh, Battery-1 Nominal Voltage (Vb1) 350 V, Battery-2 Nominal Voltage (Vb2) 450 V, Switching Frequency (fsw) 20 kHz, Filter Inductor (L1) 0.5 mH, L1 Internal Resistance (R1) 0.005 Ω, Filter Inductor (L2) 0.6 mH, L2 Internal Resistance (R2) 0.006 Ω, DC-link Capacitor (Ck) 1000 uF, Battery internal parameters are also considered as functions of the state-of-charge (SOC) variation to analyze open-loop stability. Based on this analysis, a PI controller is designed, and the corresponding Bode plots are ploted to assess the closed-loop system stability.

For Simulation Results Validation:
Open "MATLAB R2020b or later" version and Run. The simulation and analysis results presented in the manuscript are obtained as follows:

The Simulink model is executed and the system responses are observed from Scopes 1 and 3. These recorded waveforms are used to generate Figs. 10, 11, and 12, corresponding to the converter operation in forward boost, reverse buck, and forward buck–boost modes, respectively.

The MATLAB script files are executed to perform the stability analysis of the system. From these scripts, the frequency-domain characteristics are obtained, and the resulting Bode plots are presented in Fig. 9.

Further OPAL-RT experimentation iscarried out using the Simulink model, and the responses captured from the relevant scopes are used to generate Figs. 21, 22, and 23, illustrating the dynamic performance of the proposed system under different operating conditions.

Contact:
For questions or replication of results: bs22eer2r03@student.nitw.ac.in , ub@nitw.ac.in .
