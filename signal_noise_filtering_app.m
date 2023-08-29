% sinusoidal signal noise filtering app using MATLAB app designer

classdef NoiseFilterApp < matlab.apps.AppBase

    properties (Access = public)
        UIFigure      matlab.ui.Figure
        GenerateButton  matlab.ui.control.Button
        FilterButton  matlab.ui.control.Button
        FilterOrderSlider  matlab.ui.control.Slider
        CutoffFrequencySlider  matlab.ui.control.Slider
        SignalPlot  matlab.ui.control.UIAxes
        NoisySignalPlot  matlab.ui.control.UIAxes
        FilteredSignalPlot  matlab.ui.control.UIAxes
    end

    methods (Access = private)
        % Callback for GenerateButton
        function GenerateButtonPushed(app, event)
            fs = 10000;
            t = 0:1/fs:40;
            x = sin(pi/10*t);
            noise = 0.5*randn(size(t));
            x_withnoise = x + noise;
            
            % Plot signals
            plot(app.SignalPlot, t, x);
            plot(app.NoisySignalPlot, t, x_withnoise);
        end

        % Callback for FilterButton
        function FilterButtonPushed(app, event)
            fs = 10000;
            t = 0:1/fs:40;
            x = sin(pi/10*t);
            noise = 0.5*randn(size(t));
            x_withnoise = x + noise;

            fil_order = app.FilterOrderSlider.Value;
            cutoff_freq = app.CutoffFrequencySlider.Value;
            
            wc = cutoff_freq * 2 * pi / fs;
            filt = designfilt('lowpassfir', 'FilterOrder', fil_order, 'CutoffFrequency', wc, 'SampleRate', fs, 'DesignMethod', 'window', 'Window', 'hamming');
            
            filtered_signal = filter(filt, x_withnoise);
            
            % Plot filtered signal
            plot(app.FilteredSignalPlot, t, filtered_signal);
        end
    end

    methods (Access = public)
        % App initialization and construction
        function createComponents(app)
            % Create and configure UI components
            app.UIFigure = uifigure('Name', 'Noise Filter App');
            
            app.GenerateButton = uibutton(app.UIFigure, 'push', ...
                'Text', 'Generate Signal', ...
                'Position', [20 280 100 30], ...
                'ButtonPushedFcn', @(src, event) GenerateButtonPushed(app, event));

            app.FilterButton = uibutton(app.UIFigure, 'push', ...
                'Text', 'Filter Signal', ...
                'Position', [140 280 100 30], ...
                'ButtonPushedFcn', @(src, event) FilterButtonPushed(app, event));
            
            app.FilterOrderSlider = uislider(app.UIFigure, ...
                'Position', [20 220 220 3], ...
                'Limits', [1 100], ...
                'Value', 10);
            
            app.CutoffFrequencySlider = uislider(app.UIFigure, ...
                'Position', [20 160 220 3], ...
                'Limits', [0 5000], ...
                'Value', 1000);
            
            app.SignalPlot = uiaxes(app.UIFigure, ...
                'Position', [20 20 220 120]);
            
            app.NoisySignalPlot = uiaxes(app.UIFigure, ...
                'Position', [260 20 220 120]);
            
            app.FilteredSignalPlot = uiaxes(app.UIFigure, ...
                'Position', [500 20 220 120]);
        end

        function app = NoiseFilterApp
            createComponents(app);
            
            % Configure UIFigure properties
            app.UIFigure.Position = [100 100 740 400];
            app.UIFigure.Name = 'Noise Filter App';
            app.UIFigure.Resize = 'off';
            
            % ... other UI figure properties ...
            
            % Call startup function
            startupFcn(app);
            
            % Display the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
        
        % Code that runs when the app starts
        function startupFcn(app)
            % ... code that runs when the app starts ...
        end
    end

    methods (Static)
        % App creation and deletion
        function create
            app = NoiseFilterApp;
        end
    end
end
