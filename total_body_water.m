%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File:     total_body_water.m
% Authors:  Marcin ********
% Date:     06.03.2019r.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;

file_exists = false;
filename = 'students_data.xls';


% Open file.
try
    [values, text, all_data] = xlsread( filename );
    file_exists = true;
catch XLSREAD
    warning( 'problem with open file' );
end


% Data analysis.
if file_exists
    try
        % Calculate number of students.
        numOfStudents = size( values, 1 );
        
        % Get age of students (the output vector contain different ages).
        ages = [];
        for a = 1:numOfStudents
           if ~ismember( values(a,2), ages )
               ages = [ ages, values(a,2) ];
           end
        end
        
        % Calculate VTBW (Total Body Water) for each age group.
        Vmen = {};       % VTBW for men.
        Vwomen = {};     % VTBW for women.
        
        for a = ages
            VmenPerAge = [];
            VwomenPerAge = [];
            
            for s = 1:numOfStudents;
                % Check if the student is a man and is 'a' years old.
                if strcmp( text(s+1,5), 'M' ) && values(s,2) == a
                    % Equation for men.
                    VmenPerAge = [ VmenPerAge, 2.447 ...
                                    - 0.09516 * values(s,2) ...
                                    + 0.1074 * values(s,4) ...
                                    + 0.3362 * values(s,3) ];
                % Check if the student is a woman and is 'a' years old.
                elseif strcmp( text(s+1,5), 'K' ) && values(s,2) == a
                    % Equation for women.
                    VwomenPerAge = [ VwomenPerAge, ...
                                    -2.097 + 0.1069 * values(s,4) ...
                                    + 0.2466 * values(s,3) ];
                end
            end
            
            % Add data calculated for one year to all data. 
            Vmen{end+1} = num2cell( VmenPerAge );
            Vwomen{end+1} = num2cell( VwomenPerAge );
        end
            
    catch
        warning( 'problem with data analysis' );
    end
end


% Draw the results.
figure(1);
    subplot(2,1,1);
    hold on; grid on;
    
    Nages = length( ages );
    
    % Men's data.
    legendExist = 0;
    for a = 1:Nages
        d = cell2mat( Vmen{a} );
        % Add data to the graph if data exists.
        if d
            % Create a legend only once.
            plot( ages(a), mean( d ), 'ro', ages(a), d, 'b*' );
            if ~legendExist && ~isempty( d )
                legend( 'œrednia wartoœci VTBW', 'wartoœci VTBW' );
                legendExist = 1;
            end
        end
    end
    axis( [min( ages )-1 max( ages )+1 20 80] );
    title( 'VTBW dla mê¿czyzn' );
    xlabel( 'wiek [lata]');
    

    subplot(2,1,2);
    hold on; grid on;
    
    % Women's data.
    legendExist = 0;
    for a = 1:Nages
        d = cell2mat( Vwomen{a} );
        % Add data to the graph if data exists.
        if d
            plot( ages(a), mean( d ), 'ro', ages(a), d, 'b*');
            % Create a legend only once.
            if ~legendExist && ~isempty( d )
                legend( 'œrednia wartoœci VTBW', 'wartoœci VTBW' ); 
                legendExist = 1;
            end
        end
    end
    axis( [min( ages )-1 max( ages )+1 20 80] );
    title( 'VTBW dla kobiet' );
    xlabel( 'wiek [lata]' );