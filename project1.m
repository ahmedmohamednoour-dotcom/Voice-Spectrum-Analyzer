%GUI part with the first part of entrerring thee data 
choice = menu("Choose an input method:", "Upload Audio File", "Record from Microphone");

if choice == 1
    [nameFile, pathAudio] = uigetfile({'*.mp3;*.wav'}, 'Select an mp3 or wav file', '');
    if isequal(nameFile, 0)
        disp('You have not selected any audio file.');
        return;
    end
    audioFile = fullfile(pathAudio, nameFile);
    [y, fs] = audioread(audioFile);
    disp('Audio file loaded successfully.');
else
    disp('Microphone recording selected.');

    prompt = {"Tmax", "Fsample"};
    dlg_title = "Microphone Recording Settings";
    default_values = {"5", "16000"};
    user_input = inputdlg(prompt, dlg_title, [1, 10], default_values);

    maxTime = str2double(user_input{1});
    fs = str2double(user_input{2});

    recObj = audiorecorder(fs, 16, 1);
    disp('Start speaking...');
    recordblocking(recObj, maxTime);
    disp('Recording complete.');
    y = getaudiodata(recObj);

    saveChoice = questdlg('Would you like to save the recorded audio?', 'Save Audio', 'Yes', 'No', 'Yes');
    if strcmp(saveChoice, 'Yes')
        [saveName, savePath] = uiputfile({'*.wav'}, 'Save Recorded Audio', 'recorded_audio.wav');
        if saveName ~= 0
            audiowrite(fullfile(savePath, saveName), y, fs);
            disp('Audio file saved successfully.');
        else
            disp('Audio not saved.');
        end
    end
end

%calculate the constants 

frameLength = 512 * 3;
Tss = frameLength / fs;
L = frameLength;
NFFT = 2 ^ nextpow2(L);
f = linspace(0, fs / 2, NFFT / 2);
h = 0.54 - 0.46 * cos(2 * pi * (0:L-1)' / (L-1));

%creating figures and plots 
%figure of the amplitude-time graph
figure('Name', 'DSP - Signal and Spectrum Visualization', 'Color', [1, 1, 1]);

subplot(3, 1, 1);
timeAxis = gca;
title('Audio Signal (Time Domain)', 'FontSize', 14, 'Color', 'k');
xlabel('Time [s]', 'FontSize', 12, 'Color', 'k');
ylabel('Amplitude', 'FontSize', 12, 'Color', 'k');
grid on;
set(gca, 'Color', [1, 1, 1], 'XColor', 'k', 'YColor', 'k', 'GridColor', [0.5, 0.5, 0.5]);
hold on;
%figure of the frequency graphs
figure('Name', 'DSP - Signal and Spectrum Visualization', 'Color', [1, 1, 1]);

subplot(3, 1, 1);
freqAxis = gca;
title('Audio Spectrum (Amplitude) in Frequency Domain', 'FontSize', 14, 'Color', 'k');
xlabel('Frequency [Hz]', 'FontSize', 12, 'Color', 'k');
ylabel('Amplitude', 'FontSize', 12, 'Color', 'k');
grid on;
set(gca, 'Color', [1, 1, 1], 'XColor', 'k', 'YColor', 'k', 'GridColor', [0.5, 0.5, 0.5]);
hold on;

subplot(3, 1, 2);
energyAxis = gca;
title('Audio Spectrum (Energy) in Frequency Domain', 'FontSize', 14, 'Color', 'k');
xlabel('Frequency [Hz]', 'FontSize', 12, 'Color', 'k');
ylabel('Energy', 'FontSize', 12, 'Color', 'k');
grid on;
set(gca, 'Color', [1, 1, 1], 'XColor', 'k', 'YColor', 'k', 'GridColor', [0.5, 0.5, 0.5]);
hold on;

subplot(3, 1, 3);
phaseAxis = gca;
title('Phase Spectrum (Frequency Domain)', 'FontSize', 14, 'Color', 'k');
xlabel('Frequency [Hz]', 'FontSize', 12, 'Color', 'k');
ylabel('Phase [Degrees]', 'FontSize', 12, 'Color', 'k');
grid on;
set(gca, 'Color', [1, 1, 1], 'XColor', 'k', 'YColor', 'k', 'GridColor', [0.5, 0.5, 0.5]);
hold on;


%figure of the control panel 
figure('Name', 'Control Panel', 'Color', [1, 1, 1], 'Position', [100, 100, 400, 500]);
uicontrol('Style', 'text', 'Position', [50, 460, 300, 20], 'String', 'Control Panel', 'FontSize', 12);

uicontrol('Style', 'pushbutton', 'Position', [50, 400, 150, 30], 'String', 'Zoom X-axis (Frequency)', ...
    'Callback', @(~, ~) zoomXAxis(freqAxis));

uicontrol('Style', 'pushbutton', 'Position', [50, 350, 150, 30], 'String', 'Zoom Y-axis (Frequency)', ...
    'Callback', @(~, ~) zoomYAxis(freqAxis));

uicontrol('Style', 'pushbutton', 'Position', [50, 300, 150, 30], 'String', 'Zoom X-axis (Time)', ...
    'Callback', @(~, ~) zoomXAxis(timeAxis));

uicontrol('Style', 'pushbutton', 'Position', [50, 250, 150, 30], 'String', 'Zoom Y-axis (Time)', ...
    'Callback', @(~, ~) zoomYAxis(timeAxis));

%Part of processing the frame and claculationg the graphs

bufferSize = 2;
buffer_y = zeros(frameLength * bufferSize, size(y, 2));
t = 0;

for i = 1:frameLength:(length(y) - frameLength)
    currentFrame = y(i:i+frameLength-1, :) .* h;

    buffer_y(1:frameLength, :) = currentFrame;

    t = t + Tss;
    t_audio = linspace(t - Tss, t, frameLength);
    plot(timeAxis, t_audio, currentFrame(:, 1), 'r', 'LineWidth', 1.5);
    if size(y, 2) > 1
        plot(timeAxis, t_audio, currentFrame(:, 2), 'b', 'LineWidth', 1.5);
    end
    % equations of the graphs 

    Y = fft(currentFrame, NFFT);
    Ymag = abs(Y(1:NFFT/2, :));
    Yenergy = Ymag.^2;
    phase = angle(Y(1:NFFT/2, :)) * (180 / pi);

    plot(freqAxis, Ymag(:, 1), 'r', 'LineWidth', 1.5);
    if size(y, 2) > 1
        plot(freqAxis, Ymag(:, 2), 'b', 'LineWidth', 1.5);
    end

    plot(energyAxis, f, Yenergy(:, 1), 'r', 'LineWidth', 1.5);
    if size(y, 2) > 1
        plot(energyAxis, f, Yenergy(:, 2), 'b', 'LineWidth', 1.5);
    end

    plot(phaseAxis, f, phase(:, 1), 'r', 'LineWidth', 1.5);
    if size(y, 2) > 1
        plot(phaseAxis, f, phase(:, 2), 'b', 'LineWidth', 1.5);
    end

    drawnow;
end

%2 functions of changing the scale in the time and frequency 
function zoomXAxis(axisHandle)
    userInput = inputdlg('Enter range (min max):', 'Zoom X-axis');
    if isempty(userInput)
        disp('Zoom canceled.');
        return;
    end
    range = str2double(split(userInput{1}));
    if numel(range) ~= 2 || any(isnan(range)) || range(1) >= range(2)
        errordlg('Invalid range. Please enter two increasing numeric values.', 'Error');
        return;
    end
    xlim(axisHandle, range);
    disp(['X-axis range updated to: [', num2str(range(1)), ', ', num2str(range(2)), ']']);
end

function zoomYAxis(axisHandle)
    userInput = inputdlg('Enter range (min max):', 'Zoom Y-axis');
    if isempty(userInput)
        disp('Zoom canceled.');
        return;
    end
    range = str2double(split(userInput{1}));
    if numel(range) ~= 2 || any(isnan(range)) || range(1) >= range(2)
        errordlg('Invalid range. Please enter two increasing numeric values.', 'Error');
        return;
    end
    ylim(axisHandle, range);
    disp(['Y-axis range updated to: [', num2str(range(1)), ', ', num2str(range(2)), ']']);
end
