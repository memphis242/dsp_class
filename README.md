#dsp_class  

### Summary
This repo is meant to hold any of the C and MATLAB programming I did over the course of my Applied Digital Signal Processing class (ECE444) here at North Dakota State University. There are also some KiCAD files for a little audio amplifier board I made for the last assignment of the class, which involved making an equalizer FIR filter for some audio processing. Even though this class at times felt like climbing Mount Everest in the depths of winter naked, it is easily one of **my favorite classes of all time**. The challenge was great, I learned a lot, and some serious black magic was witnessed!  

### What Types of Problems Were Encounted In These Classes
We used the [FRDM K22F development board from NXP](https://www.nxp.com/design/development-boards/freedom-development-boards/mcu-boards/nxp-freedom-development-platform-for-kinetis-k22-mcus:FRDM-K22F) to implement what we learned in lecture onto a DSP. We demonstrated to ourselves digital Fourier Series, DFTs, and slowly worked our way to making the highest order IIR and FIR filters we could. Along the way, we also had to come up with efficient programming to ensure we wasted as little time as we could.  

### Structure of This Repo and How To Navigate Through
There are a lot of MATLAB function files spread all throughout, along with image files and pdfs. This makes the repo as it stands as of 10/30/2021 *pretty messy*. I do not have time to organize it at the moment, but plan to get to it as soon as I can. For now, the best way to browse through the repo is to go through my assignments. The folders have a title to indicate what the assignment was primarily about, at least as far as a lab was concerned.  

Note, for the most part, after getting the development environment set up, all we really worked on was whatever went into the timer interrupt ISR. Within the interrupt, we would sample from the ADC, then do some processing, then output the result onto the DAC. We did not care to do much anything else, so we violated a lot of the general rules for interrupt routines, and at run-time, the board spent 80-90% of its time in the ISR... Part of the reason for this was we wanted to get the highest order filters we could, and with filter order, the needed computations grew! For the final assignment, where we made an FIR filter to produce an equalizer for audio processing, we even utilized fixed-point arithmetic. I myself was able to get my filter to an order of 600, which was awesome! However, I scaled it down to an order of 50 I believe, as it was more than sufficient to meet my needs.  

Finally, for the IIR and FIR filter code, 70% of the work was done in MATLAB. The reason being was we had to come up with code to generate the coefficients needed for whatever filter we were designing, and the scripts had to be generic enough that we could change specifications (like pass-band and stop-band requirements) and not have to re-write the entire scripts. The deliverable from the code was a header file (something like "coeff.h") that would be included within main.c for each assignment uVision project.

### References
