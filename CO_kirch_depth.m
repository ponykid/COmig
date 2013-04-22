%{

CO_kirch_depth.m - Common offset Kirchhoff depth-migration.
Copyright (C) 2013 Jesper S Dramsch, Matthias Schneider,
                   Dela Spickermann, Jan Walda

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
%}

function [COG, Skala] = CO_kirch_depth(data, v, h, dt, dcmp, half_aper)

%% Interpolation from t to z domain
% must be calculated before because aperture may need data in front
% of the current cmp
for i_cmp = 1:ns
    filt_interp(:,i_cmp,i_h) = interp1(t_depth,...
        filtdata(:,i_cmp,i_h),z,'spline');
end

%% Loop over CMPs
for i_cmp = 1:ns
    % Aperture limits
    bound_l = max(floor(i_cmp-h_aper), 1);
    bound_r = min(floor(i_cmp+h_aper), ns);
    
    % Control if everything runs smoothly
    disp(['     CMP ||' ' left boundary ||'...
        ' right boundary ||' ' half aperture ||' ' velocity']);
    disp([(i_cmp-1)*dcmp (bound_l-1)*dcmp...
        (bound_r-1)*dcmp h_aper*dcmp v]);
    %% Loop over contributing samples (Aperture)
    for i_aper=bound_l:bound_r
        
        %% Loop over Depth
        for i_z=1:length(z)
            
            % Compute diffraction hyperbola, /2 because data is TWT
            zdiff = 0.5*( sqrt(z(i_z)^2 ...
                + ((i_cmp-i_aper)*dcmp-h(i_h)).^2) ...
                + sqrt(z(i_z)^2 ...
                + ((i_cmp-i_aper)*dcmp+h(i_h)).^2) );
            
            % Exit if diffraction ist out of data
            if(zdiff > (max(z)))
                break;
            end
            
            %% Interpolate zdiff
            % ! only if with interpolation at zdiff
            if(interpolate==1)
                res_interp = interp1(z,...
                    filt_interp(:,i_aper,i_h),zdiff,'spline');
            end
            %% Compute amplitude correction
            cosphi = z(i_z)/sqrt(z(i_z)^2+h(i_h)^2);
            weight = cosphi/sqrt(zdiff*v);
            
            %% Sum up along diffraction
            % ! with interpolation at zdiff
            if(interpolate==1)
                COG(i_z,i_cmp,i_h) = COG(i_z,i_cmp,i_h) ...
                    + res_interp * weight;
            elseif(interpolate==0)
                i_zdiff = floor(1.5+zdiff/dz);
                % +0.5 so it get rounded correctly and + 1 so its
                % start with index 1, +1+0.5 = +1.5
                
                % ! without interpolation at zdiff
                COG(i_z,i_cmp,i_h) = COG(i_z,i_cmp,i_h) ...
                    + filt_interp(i_zdiff,i_aper,i_h) * weight;
            else
                disp('Error, no valid method!');
            end
        end
    end
end
COG(1,:,i_h) = 0;         % NaN avoiding
return


