% bibus Give me the next bus
%
% [] = bibus()
% 
% HELPTEXT
%
%
% Created: 2009-05-05.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = bibus(varargin)

method = 2;

switch method
	case 1
		%Liberte = 'StopArea%7C202%7CLibert%E9%7CBrest%7C%7C%7C95195%2C14%7C2398794%2C29%7C416%210%3B414%210%3B413%210%3B412%210%3B415%210%3B411%210%3B417%210%3B';
		%Piccard = 'StopArea%7C516%7CPiccard%7CPlouzan%E9%7C%7C%7C89155%2C00%7C2396159%2C50%7C1056%210%3B1055%210%3B';
		Piccard = 'StopArea%7C513%7CPiccard%7CPlouzan%E9%7C%7C%7C89155%2C00%7C2396159%2C50%7C1055%210%3B1056%210%3B';
		Liberte = 'StopArea%7C193%7CLibert%E9%20S%E9galen%7CBrest%7C%7C%7C95004%2C00%7C2398930%2C00%7C389%210%3B388%210%3B';
		
		if str2num(datestr(now,'HH')) > 12
			% This is the afternoon, we come back home !
			DPoint = Piccard;
			APoint = Liberte;
		else
			% This is the morning, we go to work !
			DPoint = Liberte;
			APoint = Piccard;
		end

		base   = 'http://bibus.prod.navitia.com/navitia/ITI_2_AnswersList.asp?';
		Date   = sprintf('%4s%%7C%2s%%7C%0.0f',datestr(now,'yyyy'),datestr(now,'mm'),str2num(datestr(now,'dd')));
		Time   = sprintf('1%%7C%0.0f%%7C%0.0f',str2num(datestr(now,'HH')),str2num(datestr(now,'MM')));
		suffix = '&CmbDate=0&Criteria=1%7C%7C&PMR=0&Equipment=&Vehicle=&Mode=%7C1%7CPas%20de%20pr%E9f%E9rences%7C&Extend=&DateFinBases=2009%7C08%7C30&DateMajBases=2009%7C04%7C28';
		url = sprintf('%sDPoint=%s&APoint=%s&Date=%s&Time=%s&%s',base,DPoint,APoint,Date,Time,suffix);

		foutput = abspath('~/.bibus.html');
		system(sprintf('wget ''%s'' -q -O %s',url,foutput));
		fid=fopen(foutput);ALL='';
		while 1
		    tline = fgetl(fid);
		    if ~ischar(tline), break, end
			ALL=[ALL tline];
		%    disp(tline)
		end
		fclose(fid);
		%disp(ALL)
		ALL=strrep(ALL,'href="../Navitia_params/','href="http://bibus.prod.navitia.com/Navitia_params/');
		fid=fopen(foutput,'wt');
		fprintf(fid,'%s',ALL);
		fclose(fid);

		web(sprintf('file:%s',foutput), '-browser');


	case 2
		ye = str2num(datestr(now,'yyyy'));
		mo = str2num(datestr(now,'mm'));
		da = str2num(datestr(now,'dd'));
		if datestr(now,'ddd') == 'Sat' | datestr(now,'ddd') == 'Sun'
			error('Pas d''horaires pour le week-end !');
		end
		if now < datenum(2009,8,31,0,0,0) | now > datenum(2010,6,27,0,0,0)
			error('Les horaires dont je dispose ne sont plus valide pour aujourd''hui');
		end
		vacances = [datenum(2009,10,25,0,0,0):datenum(2009,11,4,0,0,0) ...
					datenum(2009,12,20,0,0,0):datenum(2010,1,3,0,0,0) ...
					datenum(2010,2,14,0,0,0):datenum(2010,2,18,0,0,0) ...
					datenum(2010,4,11,0,0,0):datenum(2010,4,25,0,0,0)];
					
		% Semaine Vacances Scolaires:			
		if ~isempty(find(vacances==datenum(ye,mo,da,0,0,0)))
			disp('Warning: Horaires de Semaine Vacances Scolaires');
			% Brest-Ifremer:
			dir1 = [...
					datenum(ye,mo,da,6,35,0),...
					datenum(ye,mo,da,7,16,0),...
					datenum(ye,mo,da,7,28,0),...
					datenum(ye,mo,da,7,55,0),...
					datenum(ye,mo,da,8,26,0),...
					datenum(ye,mo,da,8,53,0),...
					datenum(ye,mo,da,9,10,0),...
					datenum(ye,mo,da,9,40,0),...
					datenum(ye,mo,da,10,12,0),...
					datenum(ye,mo,da,10,42,0),...
					datenum(ye,mo,da,11,18,0),...
					datenum(ye,mo,da,11,48,0),...
					datenum(ye,mo,da,12,22,0),...
					datenum(ye,mo,da,12,47,0),...
					datenum(ye,mo,da,13,20,0),...
					datenum(ye,mo,da,13,55,0),...
					datenum(ye,mo,da,14,28,0),...
					datenum(ye,mo,da,15,0,0),...
					datenum(ye,mo,da,15,31,0),...
					datenum(ye,mo,da,16,6,0),...
					datenum(ye,mo,da,16,38,0),...
					datenum(ye,mo,da,17,10,0),...
					datenum(ye,mo,da,17,43,0),...
					datenum(ye,mo,da,18,10,0),...
					datenum(ye,mo,da,18,40,0),...
					datenum(ye,mo,da,19,10,0),...
					datenum(ye,mo,da,19,30,0),...
					datenum(ye,mo,da,20,12,0)];
			% Ifremer-Brest:					
			dir2 = [...
					datenum(ye,mo,da,6,44,0),...
					datenum(ye,mo,da,7,4,0),...
					datenum(ye,mo,da,7,21,0),...
					datenum(ye,mo,da,7,59,0),...
					datenum(ye,mo,da,8,24,0),...
					datenum(ye,mo,da,8,43,0),...
					datenum(ye,mo,da,9,25,0),...
					datenum(ye,mo,da,10,10,0),...
					datenum(ye,mo,da,10,39,0),...
					datenum(ye,mo,da,11,11,0),...
					datenum(ye,mo,da,11,43,0),...
					datenum(ye,mo,da,12,23,0),...
					datenum(ye,mo,da,12,51,0),...
					datenum(ye,mo,da,13,22,0),...
					datenum(ye,mo,da,13,51,0),...
					datenum(ye,mo,da,14,29,0),...
					datenum(ye,mo,da,14,58,0),...
					datenum(ye,mo,da,15,32,0),...
					datenum(ye,mo,da,16,3,0),...
					datenum(ye,mo,da,16,36,0),...
					datenum(ye,mo,da,17,14,0),...
					datenum(ye,mo,da,17,48,0),...
					datenum(ye,mo,da,18,19,0),...
					datenum(ye,mo,da,18,51,0),...
					datenum(ye,mo,da,19,22,0),...
					datenum(ye,mo,da,20,9,0),...
					datenum(ye,mo,da,20,42,0)];
		% Semaine Periode Scolaire:	
		else 
			disp('Semaine Periode Scolaire');
			% Brest-Ifremer:
			dir1 = [...
				datenum(ye,mo,da,6,34,0),...
				datenum(ye,mo,da,7,16,0),...
				datenum(ye,mo,da,7,26,0),...
				datenum(ye,mo,da,7,58,0),...
				datenum(ye,mo,da,8,25,0),...
				datenum(ye,mo,da,8,55,0),...
				datenum(ye,mo,da,9,10,0),...
				datenum(ye,mo,da,9,45,0),...
				datenum(ye,mo,da,10,13,0),...
				datenum(ye,mo,da,10,43,0),...
				datenum(ye,mo,da,11,17,0),...
				datenum(ye,mo,da,11,48,0),...
				datenum(ye,mo,da,12,20,0),...
				datenum(ye,mo,da,12,37,0),...
				datenum(ye,mo,da,13,20,0),...
				datenum(ye,mo,da,13,55,0),...
				datenum(ye,mo,da,14,25,0),...
				datenum(ye,mo,da,14,56,0),...
				datenum(ye,mo,da,15,18,0),...
				datenum(ye,mo,da,15,39,0),...
				datenum(ye,mo,da,16,0,0),...
				datenum(ye,mo,da,16,34,0),...
				datenum(ye,mo,da,17,2,0),...
				datenum(ye,mo,da,17,25,0),...
				datenum(ye,mo,da,17,50,0),...
				datenum(ye,mo,da,18,18,0),...
				datenum(ye,mo,da,18,45,0),...
				datenum(ye,mo,da,19,10,0),...
				datenum(ye,mo,da,19,32,0),...
				datenum(ye,mo,da,20,12,0)];
			% Ifremer-Brest:
			dir2 = [...
				datenum(ye,mo,da,6,42,0),...
				datenum(ye,mo,da,7,1,0),...
				datenum(ye,mo,da,7,14,0),...
				datenum(ye,mo,da,7,33,0),...
				datenum(ye,mo,da,8,0,0),...
				datenum(ye,mo,da,8,19,0),...
				datenum(ye,mo,da,8,30,0),...
				datenum(ye,mo,da,9,0,0),...
				datenum(ye,mo,da,9,25,0),...
				datenum(ye,mo,da,10,9,0),...
				datenum(ye,mo,da,10,43,0),...
				datenum(ye,mo,da,11,11,0),...
				datenum(ye,mo,da,11,43,0),...
				datenum(ye,mo,da,12,23,0),...
				datenum(ye,mo,da,12,52,0),...
				datenum(ye,mo,da,13,22,0),...
				datenum(ye,mo,da,13,40,0),...
				datenum(ye,mo,da,14,26,0),...
				datenum(ye,mo,da,15,2,0),...
				datenum(ye,mo,da,15,28,0),...
				datenum(ye,mo,da,16,3,0),...
				datenum(ye,mo,da,16,35,0),...
				datenum(ye,mo,da,16,56,0),...
				datenum(ye,mo,da,17,11,0),...
				datenum(ye,mo,da,17,42,0),...
				datenum(ye,mo,da,18,16,0),...
				datenum(ye,mo,da,18,39,0),...
				datenum(ye,mo,da,19,2,0),...
				datenum(ye,mo,da,19,25,0),...
				datenum(ye,mo,da,20,10,0),...
				datenum(ye,mo,da,20,40,0)];
		end%if
		
		
		%% ETE 2009:
		% dir1 = [...
		% 	datenum(ye,mo,da,6,35,0),...
		% 	datenum(ye,mo,da,7,10,0),...
		% 	datenum(ye,mo,da,7,32,0),...
		% 	datenum(ye,mo,da,8,7,0),...
		% 	datenum(ye,mo,da,8,34,0),...
		% 	datenum(ye,mo,da,9,10,0),...
		% 	datenum(ye,mo,da,10,12,0),...
		% 	datenum(ye,mo,da,11,10,0),...
		% 	datenum(ye,mo,da,11,45,0),...
		% 	datenum(ye,mo,da,12,20,0),...
		% 	datenum(ye,mo,da,12,45,0),...
		% 	datenum(ye,mo,da,13,26,0),...
		% 	datenum(ye,mo,da,14,6,0),...
		% 	datenum(ye,mo,da,15,0,0),...
		% 	datenum(ye,mo,da,15,55,0),...
		% 	datenum(ye,mo,da,16,16,0),...
		% 	datenum(ye,mo,da,16,50,0),...
		% 	datenum(ye,mo,da,17,25,0),...
		% 	datenum(ye,mo,da,17,50,0),...
		% 	datenum(ye,mo,da,18,26,0),...
		% 	datenum(ye,mo,da,18,59,0),...
		% 	datenum(ye,mo,da,19,22,0),...
		% 	datenum(ye,mo,da,20,12,0)];
		
		% dir2 = [...
		% 	datenum(ye,mo,da,6,44,0),...
		% 	datenum(ye,mo,da,7,12,0),...
		% 	datenum(ye,mo,da,7,31,0),...
		% 	datenum(ye,mo,da,8,5,0),...
		% 	datenum(ye,mo,da,8,28,0),...
		% 	datenum(ye,mo,da,9,4,0),...
		% 	datenum(ye,mo,da,9,34,0),...
		% 	datenum(ye,mo,da,10,26,0),...
		% 	datenum(ye,mo,da,11,11,0),...
		% 	datenum(ye,mo,da,12,10,0),...
		% 	datenum(ye,mo,da,12,45,0),...
		% 	datenum(ye,mo,da,13,20,0),...
		% 	datenum(ye,mo,da,14,4,0),...
		% 	datenum(ye,mo,da,14,31,0),...
		% 	datenum(ye,mo,da,15,25,0),...
		% 	datenum(ye,mo,da,16,6,0),...
		% 	datenum(ye,mo,da,16,57,0),...
		% 	datenum(ye,mo,da,17,18,0),...
		% 	datenum(ye,mo,da,17,54,0),...
		% 	datenum(ye,mo,da,18,30,0),...
		% 	datenum(ye,mo,da,18,58,0),...
		% 	datenum(ye,mo,da,19,28,0),...
		% 	datenum(ye,mo,da,20,39,0)];


		if str2num(datestr(now,'HH')) > 12
			% This is the afternoon, we come back home !			
			disp('Horaires des prochains bus vers Liberte:');
			d=disp_list(dir2,find(dir2>=now,4));
			if nargin == 1 % Send notification to growl for next bus
				growl(sprintf('Prochain bus a %s',datestr(dir2(find(dir2>=now,1)),'HH:MM')),...
					'Bus vers Brest-Liberte',1)
			end
		else
			% This is the morning, we go to work !
			disp('Horaires des prochains bus vers Ifremer:');
%			datestr(dir1(find(dir1>=now)))
			d=disp_list(dir1,find(dir1>=now,4));
			if nargin == 1 % Send notification to growl for next bus
				growl(sprintf('Prochain bus a %s',datestr(dir1(find(dir1>=now,1)),'HH:MM')),...
					'Bus vers Ifremer',1)
			end
		end
	
		
end  %switch
		
		
	
		
		
end %function



function d = disp_list(diri,id)
	for ii = 1 : length(id)
		dt = abs(fix(86400*(now-diri(id(ii)))/60));
		if dt > 60
			d = sprintf('%i heure(s) et %i minute(s)',fix(dt/60),rem(dt,60));
		else
			d = sprintf('%i minute(s)',dt);
		end
		disp(sprintf('   %s dans %s',datestr(diri(id(ii)),'HH:MM'),d));
	end
end












