classdef app2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        app2Main                    matlab.ui.Figure
        AverageGovernmentspendingperpersonLabel  matlab.ui.control.Label
        Gov                         matlab.ui.control.NumericEditField
        AverageOfficialDevelopmentAssistanceOtherOfficialFlowsLabel  matlab.ui.control.Label
        Aid                         matlab.ui.control.NumericEditField
        PovertyIndexEditFieldLabel  matlab.ui.control.Label
        PovIndex                    matlab.ui.control.NumericEditField
        ButtonAdd                   matlab.ui.control.Button
        CompGraph                   matlab.ui.control.UIAxes
        Title                       matlab.ui.control.EditField
        AverageCosttoAidLabel       matlab.ui.control.Label
        Cost                        matlab.ui.control.NumericEditField
        ButtonBack                  matlab.ui.control.Button
        CompGraph_2                 matlab.ui.control.UIAxes
        CompGraph_3                 matlab.ui.control.UIAxes
        GraphTrendsLabel            matlab.ui.control.Label
        NotEnoughInfoLabel          matlab.ui.control.Label
        NotExtremeLabel             matlab.ui.control.Label
        ExtremeLabel                matlab.ui.control.Label
    end

    properties (Access = private)
        ODAData = 'Data/ODA.csv'; % Accesses ODA data
        OOFData = 'Data/OOF.csv'; % Accesses OOF data
        POVData = 'Data/PPercent.csv'; % Accesses poverty population data
        GDPData = 'Data/GDP.csv'; % Accesses GDP
        ODApData = 'Data/ODAperson.csv'; % Accesses ODA per person in poverty
        countrypop = 'Data/CountryPopulation.csv'; % Accesses ODA to poverty population
        app1Main; % app1
        countryname;  % Country name
        ConstantCost; % The Constant for cost
        ODA_constant; % The ODA constant for cost
    end
    
    methods (Access = private)
       
        function POVIndex(app)
            nameind = app.countryname;
            datatable = readtable(app.POVData);
            dataind = find(string(nameind) == string(datatable.entity_name));
            if isempty(dataind)
                app.PovIndex.Value = 0;
            else
            value = zeros(1, length(dataind));
            for i = 1:length(dataind)
                value(i) = datatable.value(dataind(i));
            end
            
            zeroind = find(value ~= 0);
            actual = zeros(1, length(zeroind));
            for i = 1:length(zeroind)
                actual(i) = value(zeroind(i));
            end
            app.PovIndex.Value = (actual(end) / 10);
            end
        end

        function CompPlot(app)
            nameind = app.countryname;
            GDPtable = readtable(app.GDPData);
            ODAtable = readtable(app.ODAData);
            OOFtable = readtable(app.OOFData);
            
            GDPind = find(string(nameind) == string(GDPtable.entity_name));
            ODAind = find(string(nameind) == string(ODAtable.entity_name));
            OOFind = find(string(nameind) == string(OOFtable.entity_name));
            
            GDPvalue = zeros(1, length(GDPind));
            ODAvalue = zeros(1, length(ODAind));
            OOFvalue = zeros(1, length(OOFind));
            
            for i = 1:length(GDPind)
                GDPvalue(i) = GDPtable.value(GDPind(i));
            end
            for i = 1:length(ODAind)
                ODAvalue(i) = ODAtable.value(ODAind(i));
            end
            for i = 1:length(OOFind)
                OOFvalue(i) = OOFtable.value(OOFind(i));
            end
            
            lengths = [length(GDPvalue), length(ODAvalue), length(OOFvalue)];
            newGDPvec = zeros(1, max(lengths));
            newODAvec = zeros(1, max(lengths));
            newOOFvec = zeros(1, max(lengths));
            
            if length(GDPvalue) ~= max(lengths)
                newGDPvec(1:max(lengths) - length(GDPvalue)) = 0;
                newGDPvec(max(lengths) - length(GDPvalue) + 1:max(lengths)) = GDPvalue;
            else
                newGDPvec(1:max(lengths)) = GDPvalue;
            end
            if length(ODAvalue) ~= max(lengths)
                newODAvec(1:max(lengths) - length(ODAvalue)) = 0;
                newODAvec(max(lengths) - length(ODAvalue) + 1:max(lengths)) = ODAvalue;
            else
                newODAvec(1:max(lengths)) = ODAvalue;
            end
            if length(OOFvalue) ~= max(lengths)
                newOOFvec(1:max(lengths) - length(OOFvalue)) = 0;
                newOOFvec(max(lengths) - length(OOFvalue) + 1:max(lengths)) = OOFvalue;
            else
                newOOFvec(1:max(lengths)) = OOFvalue;
            end
            
            x = linspace(1, max(lengths), max(lengths));
            h2 = figure(); % plot figure will not show up
            set(gcf, 'Visible', 'off');
            plot(app.CompGraph,x, newGDPvec,'b');
            plot(app.CompGraph_2,x, newODAvec,'r');
            plot(app.CompGraph_3,x, newOOFvec,'g');
        end
        
        function AverageGDP(app)
            nameind = app.countryname;
            GDPtable = readtable(app.GDPData);
            GDPind = find(string(nameind) == string(GDPtable.entity_name));
            if ~isempty(GDPind)
            GDPvalue = zeros(1, length(GDPind));
            for i = 1:length(GDPind)
                if ~isnan(GDPtable.value(GDPind(i)))
                    GDPvalue(i) = GDPtable.value(GDPind(i));
                end
            end
            else
                GDPvalue = 0;
            end
            avg = sum(GDPvalue) / length(GDPvalue);
            app.Gov.Value = double(avg);
        end
        
        function AverageODAandOOF(app)
            nameind = app.countryname;
            ODAtable = readtable(app.ODAData);
            ODAind = find(string(nameind) == string(ODAtable.entity_name));
            if ~isempty(ODAind)
            ODAvalue = zeros(1, length(ODAind));
            for i = 1:length(ODAind)
                if ~isnan(ODAtable.value(ODAind(i)))
                    ODAvalue(i) = ODAtable.value(ODAind(i));
                end
            end
            else
                ODAvalue = 0;
            end
            OOFtable = readtable(app.OOFData);
            OOFind = find(string(nameind) == string(OOFtable.entity_name));
            if ~isempty(OOFind)
            OOFvalue = zeros(1, length(OOFind));
            for i = 1:length(OOFind)
                if ~isnan(OOFtable.value(OOFind(i)))
                    OOFvalue(i) = OOFtable.value(OOFind(i));
                end
            end
            else
                OOFvalue = 0;
            end
            a1 = sum(ODAvalue) / length(ODAvalue);
            a2 = sum(OOFvalue) / length(OOFvalue);
            n1 = length(ODAvalue);
            n2 = length(OOFvalue);
            weighted_avg = ((n1 / n1 + n2) * a1) + ((n2 / n1 + n2) * a2);
            app.Aid.Value = double(weighted_avg);
        end
        
        function CostCalc(app)
            nameind = app.countryname;
            countrypoptable = readtable(app.countrypop);
            countrypopind = find(string(nameind) == string(countrypoptable.country));
            if ~isempty(countrypopind)
                population = countrypoptable.population(countrypopind);
            else
                population = 0;
            end
            if app.PovIndex.Value ~= 0
                if population ~= 0
                    app.Cost.Value = ((app.PovIndex.Value / 10) * population) * app.ODA_constant;
                else
                    app.Cost.Value = app.ConstantCost;
                end
            else
                app.Cost.Value = app.ConstantCost;
            end
        end
        
        function ConstantCalc(app)
            ODAptable = readtable(app.ODApData);
            odax = ODAptable.value;
            odacount = 0;
            for i = 1:length(odax)
                if isempty(odax(i)) ~= 1
                    odacount = odacount + 1;
                end
            end

            newodavec = zeros(1, odacount);
            for i = 1:length(odax)
                if isempty(odax(i)) ~= 1
                    for j = 1:length(odacount)
                        odastrx(i) = string(odax(i));
                        newodax(i) = str2double(odastrx(i));
                        newodavec(j) = newodax(i);
                    end
                end
            end
            app.ODA_constant = sum(newodavec) / odacount;
            
            POVtable = readtable(app.POVData);
            povx = POVtable.value;
            povcount = 0;
            for i = 1:length(povx)
                if isempty(povx(i)) ~= 1
                    povcount = povcount + 1;
                end
            end

            newpovvec = zeros(1, povcount);
            for i = 1:length(povx)
                if isempty(povx(i)) ~= 1
                    for j = 1:length(povcount)
                        strpovx(i) = string(povx(i));
                        newpovx(i) = str2double(strpovx(i));
                    end
                end
            end
            povconstant = sum(newpovx) / povcount;
            
            cptable = readtable(app.countrypop);
            cpx = cptable.population;
            cpcount = 0;
            for i = 1:length(cpx)
                if isempty(cpx(i)) ~= 1
                    cpcount = cpcount + 1;
                end
            end

            newcpvec = zeros(1, cpcount);
            for i = 1:length(cpx)
                if isempty(cpx(i)) ~= 1
                    for j = 1:length(cpcount)
                        strcpx(i) = string(cpx(i));
                        newcpx(i) = str2double(strcpx(i));
                        newcpvec(j) = newcpx(i);
                    end
                end
            end
            cpconstant = sum(newcpvec) / cpcount;
            
            app.ConstantCost = ((povconstant / 100) * cpconstant) * app.ODA_constant * 12;
        end
    end


    methods (Access = private)

        % Code that executes after component creation
        function app2Start(app, mainapp, name)
            app.app1Main = mainapp;
            app.Title.Value = name;
            app.countryname = name;
            CompPlot(app);
            POVIndex(app);
            AverageGDP(app);
            AverageODAandOOF(app);
            ConstantCalc(app);
            CostCalc(app);
        end

        % Button pushed function: ButtonAdd
        function ButtonAddPushed(app, event)
            UpdateCount(app.app1Main);
            UpdateApp1(app.app1Main,app.Title.Value,app.Cost.Value);
            delete(app.app2Main);
        end

        % Button pushed function: ButtonBack
        function ButtonBackPushed(app, event)
            delete(app.app2Main);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create app2Main
            app.app2Main = uifigure;
            app.app2Main.Position = [100 100 640 480];
            app.app2Main.Name = 'UI Figure';

            % Create AverageGovernmentspendingperpersonLabel
            app.AverageGovernmentspendingperpersonLabel = uilabel(app.app2Main);
            app.AverageGovernmentspendingperpersonLabel.FontName = 'Avenir Next';
            app.AverageGovernmentspendingperpersonLabel.FontSize = 11;
            app.AverageGovernmentspendingperpersonLabel.Position = [6 132 340 22];
            app.AverageGovernmentspendingperpersonLabel.Text = 'Average Government spending per person';

            % Create Gov
            app.Gov = uieditfield(app.app2Main, 'numeric');
            app.Gov.ValueDisplayFormat = '$%5.2f';
            app.Gov.Editable = 'off';
            app.Gov.FontName = 'Avenir Next';
            app.Gov.Position = [345 132 160 22];

            % Create AverageOfficialDevelopmentAssistanceOtherOfficialFlowsLabel
            app.AverageOfficialDevelopmentAssistanceOtherOfficialFlowsLabel = uilabel(app.app2Main);
            app.AverageOfficialDevelopmentAssistanceOtherOfficialFlowsLabel.FontName = 'Avenir Next';
            app.AverageOfficialDevelopmentAssistanceOtherOfficialFlowsLabel.FontSize = 11;
            app.AverageOfficialDevelopmentAssistanceOtherOfficialFlowsLabel.Position = [6 94 330 22];
            app.AverageOfficialDevelopmentAssistanceOtherOfficialFlowsLabel.Text = 'Average Official Development Assistance & Other Official Flows';

            % Create Aid
            app.Aid = uieditfield(app.app2Main, 'numeric');
            app.Aid.ValueDisplayFormat = '$%5.2f';
            app.Aid.Editable = 'off';
            app.Aid.FontName = 'Avenir Next';
            app.Aid.Position = [345 97 160 22];

            % Create PovertyIndexEditFieldLabel
            app.PovertyIndexEditFieldLabel = uilabel(app.app2Main);
            app.PovertyIndexEditFieldLabel.HorizontalAlignment = 'right';
            app.PovertyIndexEditFieldLabel.FontName = 'Avenir Next';
            app.PovertyIndexEditFieldLabel.Position = [385 174 79 22];
            app.PovertyIndexEditFieldLabel.Text = 'Poverty Index';

            % Create PovIndex
            app.PovIndex = uieditfield(app.app2Main, 'numeric');
            app.PovIndex.ValueDisplayFormat = '%.1f';
            app.PovIndex.Editable = 'off';
            app.PovIndex.FontName = 'Avenir Next';
            app.PovIndex.Position = [479 174 162 22];

            % Create ButtonAdd
            app.ButtonAdd = uibutton(app.app2Main, 'push');
            app.ButtonAdd.ButtonPushedFcn = createCallbackFcn(app, @ButtonAddPushed, true);
            app.ButtonAdd.BackgroundColor = [0.4706 0.6706 0.1882];
            app.ButtonAdd.FontName = 'Avenir Next';
            app.ButtonAdd.FontSize = 36;
            app.ButtonAdd.Position = [541 1 100 53];
            app.ButtonAdd.Text = '+';

            % Create CompGraph
            app.CompGraph = uiaxes(app.app2Main);
            title(app.CompGraph, 'GDP')
            app.CompGraph.PlotBoxAspectRatio = [1 0.243243243243243 0.243243243243243];
            app.CompGraph.FontName = 'Avenir Next';
            app.CompGraph.Box = 'on';
            app.CompGraph.XTick = [];
            app.CompGraph.YTick = [];
            app.CompGraph.XGrid = 'on';
            app.CompGraph.YGrid = 'on';
            app.CompGraph.Position = [1 204 214 198];

            % Create Title
            app.Title = uieditfield(app.app2Main, 'text');
            app.Title.Editable = 'off';
            app.Title.HorizontalAlignment = 'center';
            app.Title.FontName = 'Avenir Next';
            app.Title.FontSize = 28;
            app.Title.Position = [1 413 640 55];

            % Create AverageCosttoAidLabel
            app.AverageCosttoAidLabel = uilabel(app.app2Main);
            app.AverageCosttoAidLabel.FontSize = 11;
            app.AverageCosttoAidLabel.Position = [6 63 338 22];
            app.AverageCosttoAidLabel.Text = 'Average Cost to Aid';

            % Create Cost
            app.Cost = uieditfield(app.app2Main, 'numeric');
            app.Cost.ValueDisplayFormat = '$%5.2f';
            app.Cost.Editable = 'off';
            app.Cost.FontName = 'Avenir Next';
            app.Cost.Position = [345 63 160 22];

            % Create ButtonBack
            app.ButtonBack = uibutton(app.app2Main, 'push');
            app.ButtonBack.ButtonPushedFcn = createCallbackFcn(app, @ButtonBackPushed, true);
            app.ButtonBack.BackgroundColor = [1 1 1];
            app.ButtonBack.FontName = 'Avenir Next';
            app.ButtonBack.FontSize = 14;
            app.ButtonBack.FontWeight = 'bold';
            app.ButtonBack.Position = [1 1 100 53];
            app.ButtonBack.Text = 'Back';

            % Create CompGraph_2
            app.CompGraph_2 = uiaxes(app.app2Main);
            title(app.CompGraph_2, 'ODA')
            app.CompGraph_2.PlotBoxAspectRatio = [1 0.243243243243243 0.243243243243243];
            app.CompGraph_2.FontName = 'Avenir Next';
            app.CompGraph_2.Box = 'on';
            app.CompGraph_2.XTick = [];
            app.CompGraph_2.YTick = [];
            app.CompGraph_2.XGrid = 'on';
            app.CompGraph_2.YGrid = 'on';
            app.CompGraph_2.Position = [214 204 214 198];

            % Create CompGraph_3
            app.CompGraph_3 = uiaxes(app.app2Main);
            title(app.CompGraph_3, 'OOF')
            app.CompGraph_3.PlotBoxAspectRatio = [1 0.243243243243243 0.243243243243243];
            app.CompGraph_3.FontName = 'Avenir Next';
            app.CompGraph_3.Box = 'on';
            app.CompGraph_3.XTick = [];
            app.CompGraph_3.YTick = [];
            app.CompGraph_3.XGrid = 'on';
            app.CompGraph_3.YGrid = 'on';
            app.CompGraph_3.Position = [427 204 214 198];

            % Create GraphTrendsLabel
            app.GraphTrendsLabel = uilabel(app.app2Main);
            app.GraphTrendsLabel.HorizontalAlignment = 'center';
            app.GraphTrendsLabel.FontName = 'Avenir Next';
            app.GraphTrendsLabel.FontSize = 20;
            app.GraphTrendsLabel.Position = [258 373 129 29];
            app.GraphTrendsLabel.Text = 'Graph Trends';

            % Create NotEnoughInfoLabel
            app.NotEnoughInfoLabel = uilabel(app.app2Main);
            app.NotEnoughInfoLabel.FontName = 'Avenir Next';
            app.NotEnoughInfoLabel.Position = [524 153 120 22];
            app.NotEnoughInfoLabel.Text = '0 = Not Enough Info.';

            % Create NotExtremeLabel
            app.NotExtremeLabel = uilabel(app.app2Main);
            app.NotExtremeLabel.FontName = 'Avenir Next';
            app.NotExtremeLabel.Position = [524 132 117 22];
            app.NotExtremeLabel.Text = '1 = Not Extreme';

            % Create ExtremeLabel
            app.ExtremeLabel = uilabel(app.app2Main);
            app.ExtremeLabel.FontName = 'Avenir Next';
            app.ExtremeLabel.Position = [524 111 117 22];
            app.ExtremeLabel.Text = '10 = Extreme';
        end
    end

    methods (Access = public)

        % Construct app
        function app = app2(varargin)

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.app2Main)

            % Execute the startup function
            runStartupFcn(app, @(app)app2Start(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.app2Main)
        end
    end
end