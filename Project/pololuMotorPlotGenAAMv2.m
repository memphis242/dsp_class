function pololuMotorPlotGenAAMv2
    clc;
    discreteBins = 500; %We will use this number of bins for plotting and calculating all functions such as Torque, speed etc.
% Input part of the main function
    StallTorque = input('Please enter the stall torque in oz-inch [17]: ');
    StallCurrent = input('Please enter the stall current in mA [700]: ');
    RatedVoltage = input('Please enter the rated voltage in Volts [6]: ');
    NoLoadCurrent = input('Please enter the free run currennt in mA [40]: ');
    NoLoadSpeed = input('Please enter the free run speed in RPM [290]: ');
    
    %Some basic input error checking is here.
    if or(not(isfloat(StallTorque)), isempty(StallTorque))
        StallTorque = 17;
        fprintf('\nUsing default value for StallTorque');
    end
    if or(not(isfloat(StallCurrent)), isempty(StallCurrent))
        StallCurrent = 700;
        fprintf('\nUsing default value for StallCurrent');
    end
    if or(not(isfloat(RatedVoltage)), isempty(RatedVoltage))
        RatedVoltage = 6;
        fprintf('\nUsing default value for RatedVoltage');
    end
    if or(not(isfloat(NoLoadCurrent)), isempty(NoLoadCurrent))
        NoLoadCurrent = 40;
        fprintf('\nUsing default value for NoLoadCurrent');
    end
    if or(not(isfloat(NoLoadSpeed)), isempty(NoLoadSpeed))
        NoLoadSpeed = 290;
        fprintf('\nUsing default value for NoLoadSpeed');
    end
    %
    
    %Here we calculate basic stuff to get all the variables and outputs.
    Resistance = RatedVoltage / (StallCurrent/1000);

    %Torque line
    TorqueLine = 0:(StallTorque/discreteBins):StallTorque;
    %Current Line
    CurrentLine = NoLoadCurrent:(StallCurrent-NoLoadCurrent)/discreteBins:StallCurrent;
    %Speed Line
    SpeedLine = NoLoadSpeed: (0-NoLoadSpeed)/discreteBins : 0;
    % Torque Constant in Torque per current is
    SlopeOfTorqueVsCurrent = (StallTorque - 0) / (StallCurrent - NoLoadCurrent);
    
    
    %Output Mechanical Power in watts is Torque * Speed * 0.00074 watts
    OutputPower = 0.00074 * TorqueLine .* SpeedLine;
    %Input Electrical Power to the motor is Voltage * Current
    InputPower = CurrentLine * RatedVoltage / 1000; %We are dividing by 1000 as the input was in mA and we need power in Watts.
    
%Plot part of the functions    
    subplot(2,2,1)
    [hAx, hLine1, hLine2] = plotyy([0 StallTorque], [NoLoadSpeed 0], [0 StallTorque], [NoLoadCurrent StallCurrent]); %This is the TorqueLoad vs. Motor Speed graph
    
    title('Torque vs. Speed & Torque vs. Current');
    xlabel('Torque (oz-in)');
    ylabel(hAx(1), 'Speed-RPM');
    ylabel(hAx(2), 'Current-mA');
    
    %This is the plot of the Output Mechanical power in watts vs. Input
    %Electrical power in Watts.
    subplot(2,2,2);
    
    [h2Ax, h2Line1, h2Line2] = plotyy(TorqueLine, OutputPower, TorqueLine, InputPower);
    xlabel('Torque (oz-in)');
    ylabel(h2Ax(1), 'OutputPower-watts');
    ylabel(h2Ax(2), 'InputPower-watts');
    title('Torque vs. Output Power & Torque vs. Input Power');
    
    %This is the plot of the Power Efficiency of the motor.
    subplot(2,2,3);
    PowerEff = OutputPower ./ InputPower;
    plot(TorqueLine, PowerEff);
    xlabel('Torque (oz-in)');
    ylabel('Power Efficiency -nounit');
    
    %Output information part of the function    
    toNmA = 7.0615;
    fprintf('\n\n\nSlope of TorqueVsCurrent is %f in oz-in per mA. The recprocal is %f in ma per oz-in\n', SlopeOfTorqueVsCurrent, (1/SlopeOfTorqueVsCurrent));
    fprintf('Hence the torque constant Kt is %f in N.m per A\n', SlopeOfTorqueVsCurrent*toNmA);
    %Max Output Power is at
    [V,I] = max(OutputPower);
    fprintf('Maximum output mechanical power is %f(watts).\nThis happens at the Torque load of %f(oz-in), with Current %f(mA)\n', OutputPower(I), TorqueLine(I), CurrentLine(I));
    fprintf('Resistance of the motor is %f (ohms)\n', Resistance);
    
end