classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        app1Main                  matlab.ui.Figure
        OrganisationforEconomicCooperationandDevelopmentLabel  matlab.ui.control.Label
        CountriesListBoxLabel     matlab.ui.control.Label
        CountriesListBox          matlab.ui.control.ListBox
        BudgetEditFieldLabel      matlab.ui.control.Label
        Budget                    matlab.ui.control.NumericEditField
        GDPGraph                  matlab.ui.control.UIAxes
        AidingListBoxLabel        matlab.ui.control.Label
        AidingListBox             matlab.ui.control.ListBox
        FinancialBudgetToolLabel  matlab.ui.control.Label
    end

    properties (Access = private)
       CNData = 'Data/CountryNames.csv';  % Accesses for Country Names
       GDPfile = 'Data/GDPGraph.csv'; % Accesses GDP Table
       app2Main % app2
    end

    properties (Access = public)
        FuncCount = 0; % Description
    end

    methods (Access = private)
    
        function ItemBox(app) % for country names
            country_name = readtable(app.CNData);
            [r,~] = size(country_name);
            for i = 1:r
                string(country_name.entity_name(i));
                app.CountriesListBox.Items(i) = [country_name.entity_name(i)];
            end
        end

        function GDPplot(app) % for GDP graph
            GDPVal = readtable(app.GDPfile);
            h1 = figure(); % plot figure will not show up
            set(gcf, 'Visible', 'off');
            hold on;
            plot(app.GDPGraph, GDPVal.Gambia);
            plot(app.GDPGraph, GDPVal.Vanuatu);
            plot(app.GDPGraph, GDPVal.Comoros);
            plot(app.GDPGraph, GDPVal.SaoTome);
            plot(app.GDPGraph, GDPVal.Kiribati);
            legend(app.GDPGraph,{'Gambia', 'Vanuatu', 'Comoros', 'SaoTome', 'Kiribati'}, 'Location', 'Southwest');
        end
        
    end

    methods (Access = public)
        
        function UpdateApp1(app, title, cost)
            app.AidingListBox.Items(app.FuncCount) = {title};
            app.Budget.Value = app.Budget.Value - cost;
        end
        
        function UpdateCount(app)
            app.FuncCount = app.FuncCount + 1;
        end
        
    end


    methods (Access = private)

        % Code that executes after component creation
        function app1Start(app)
            ItemBox(app);
            GDPplot(app);
        end

        % Value changed function: CountriesListBox
        function CountrySelected(app, event)
            value = app.CountriesListBox.Value;
            app.app2Main = app2(app, value);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create app1Main
            app.app1Main = uifigure;
            app.app1Main.Color = [0.9412 0.9412 0.9412];
            app.app1Main.Position = [100 100 640 480];
            app.app1Main.Name = 'Main Menu';

            % Create OrganisationforEconomicCooperationandDevelopmentLabel
            app.OrganisationforEconomicCooperationandDevelopmentLabel = uilabel(app.app1Main);
            app.OrganisationforEconomicCooperationandDevelopmentLabel.HorizontalAlignment = 'center';
            app.OrganisationforEconomicCooperationandDevelopmentLabel.FontName = 'Avenir Next';
            app.OrganisationforEconomicCooperationandDevelopmentLabel.FontSize = 20;
            app.OrganisationforEconomicCooperationandDevelopmentLabel.Position = [44 425 557 29];
            app.OrganisationforEconomicCooperationandDevelopmentLabel.Text = 'Organisation for Economic Co-operation and Development';

            % Create CountriesListBoxLabel
            app.CountriesListBoxLabel = uilabel(app.app1Main);
            app.CountriesListBoxLabel.HorizontalAlignment = 'right';
            app.CountriesListBoxLabel.FontName = 'Avenir Next';
            app.CountriesListBoxLabel.FontSize = 10;
            app.CountriesListBoxLabel.Position = [21 314 50 22];
            app.CountriesListBoxLabel.Text = 'Countries';

            % Create CountriesListBox
            app.CountriesListBox = uilistbox(app.app1Main);
            app.CountriesListBox.Items = {};
            app.CountriesListBox.ValueChangedFcn = createCallbackFcn(app, @CountrySelected, true);
            app.CountriesListBox.FontName = 'Avenir Next';
            app.CountriesListBox.FontSize = 10;
            app.CountriesListBox.Position = [86 171 100 167];
            app.CountriesListBox.Value = {};

            % Create BudgetEditFieldLabel
            app.BudgetEditFieldLabel = uilabel(app.app1Main);
            app.BudgetEditFieldLabel.HorizontalAlignment = 'center';
            app.BudgetEditFieldLabel.FontName = 'Avenir Next';
            app.BudgetEditFieldLabel.Position = [324 60 317 22];
            app.BudgetEditFieldLabel.Text = 'Budget';

            % Create Budget
            app.Budget = uieditfield(app.app1Main, 'numeric');
            app.Budget.ValueDisplayFormat = '$%.2f';
            app.Budget.FontName = 'Avenir Next';
            app.Budget.Position = [324 39 317 22];

            % Create GDPGraph
            app.GDPGraph = uiaxes(app.app1Main);
            title(app.GDPGraph, 'GDP of least developed countries')
            xlabel(app.GDPGraph, 'Year')
            ylabel(app.GDPGraph, 'GDP (Billion US$)')
            app.GDPGraph.PlotBoxAspectRatio = [1 0.412698412698413 0.412698412698413];
            app.GDPGraph.FontName = 'Avenir Next';
            app.GDPGraph.Box = 'on';
            app.GDPGraph.XTick = [1 2 3 4 5 6 7];
            app.GDPGraph.XTickLabel = {'2012'; '2013'; '2014'; '2015'; '2016'; '2017'};
            app.GDPGraph.YTick = [100000000 200000000 300000000 400000000 500000000 600000000 700000000 800000000 900000000 1000000000];
            app.GDPGraph.YTickLabel = {''; '0.2'; ''; '0.4'; ''; '0.6'; ''; '0.8'; ''; '1.0'};
            app.GDPGraph.NextPlot = 'add';
            app.GDPGraph.XGrid = 'on';
            app.GDPGraph.YGrid = 'on';
            app.GDPGraph.Position = [197 111 444 245];

            % Create AidingListBoxLabel
            app.AidingListBoxLabel = uilabel(app.app1Main);
            app.AidingListBoxLabel.HorizontalAlignment = 'right';
            app.AidingListBoxLabel.FontName = 'Avenir Next';
            app.AidingListBoxLabel.FontSize = 10;
            app.AidingListBoxLabel.Position = [35 148 36 22];
            app.AidingListBoxLabel.Text = 'Aiding';

            % Create AidingListBox
            app.AidingListBox = uilistbox(app.app1Main);
            app.AidingListBox.Items = {};
            app.AidingListBox.FontName = 'Avenir Next';
            app.AidingListBox.FontSize = 10;
            app.AidingListBox.Position = [86 5 100 167];
            app.AidingListBox.Value = {};

            % Create FinancialBudgetToolLabel
            app.FinancialBudgetToolLabel = uilabel(app.app1Main);
            app.FinancialBudgetToolLabel.HorizontalAlignment = 'center';
            app.FinancialBudgetToolLabel.FontName = 'Avenir Next';
            app.FinancialBudgetToolLabel.FontSize = 20;
            app.FinancialBudgetToolLabel.Position = [221 397 203 29];
            app.FinancialBudgetToolLabel.Text = 'Financial Budget Tool';
        end
    end

    methods (Access = public)

        % Construct app
        function app = app1

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.app1Main)

            % Execute the startup function
            runStartupFcn(app, @app1Start)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.app1Main)
        end
    end
end