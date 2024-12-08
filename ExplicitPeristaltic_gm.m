classdef ExplicitPeristaltic_gm
  
  methods (Static=true)  
  
    function data = main
      close all;
      % set bounds
      xmin = 0;
      xmax = 1;
      tmin = 0;
      tmax = 10;
      
      % define deltas
      delx = 1/20;
      delt = 1/800;
      
      % define 
      xvals = xmin:delx:xmax;
      tvals = tmin:delt:tmax;
      
      % define 2d mesh array
      u = zeros(length(tvals), length(xvals));
      
      % set initial condition (t=0)
      %ICpos = xvals;
        ICpos = 0*xvals;
      
      u(1, :)= ICpos;
      
      % make u
      for idx = 2:length(tvals)
        prev1 = u(idx-1, :);
        
        if idx == 2
          prev2 = nan;
        else
          prev2 = u(idx-2, :);
        end
        
        t = (idx-1)*delt;
        
        u(idx, :) = ExplicitPeristaltic_gm.solve1(prev1, prev2, xvals, t, delx, delt);
      end
  
      
      vars = who;
      for ll = 1:length(vars)
        data.(vars{ll}) = eval(vars{ll});
      end
    end

    %%
    % define helper functions
    function col = friction(tslope)
        % set friction coefs
        F_0 = 1e3; 
        F_1 = 1e4;
        a = 5;
      
        col = (F_1*tslope.^2+F_0);
        col(tslope<0) = -a*F_1*(tslope(tslope<0)).^2-F_0;
        col(tslope == 0)= 0;
      
    end

    % forcing function derivative
    function nums = forcing(x, t)
    % set coefs
      f_0 = 2000;
      k = 3/2*pi;
      w = pi;
      
      % equation
      nums = k*f_0*cos(k*x-w*t);
    end

    % solver
    function col = solve1(prev1, prev2, xvals, t,delx, delt)
      % set coefs
      Q = 0.1964*5e-5;
      P = 1100;
      mu = 1000;
      
      R = P/(delt^2);
      
      % check prev2
      if isnan(prev2)
        prev2 = prev1;
        ut = zeros(size(prev1));
      else
        ut = (prev1-prev2)/delt;
      end
      
      % set uxx
      uxx = ([prev1(2:end),0]-2*prev1+[0,prev1(1:end-1)])/(delx^2);
      
      % patch the endpoints
      uxx([1 end]) = uxx([2 (end-1)]);
      
      forcing_data = ExplicitPeristaltic_gm.forcing(xvals, t);
      friction_data = ExplicitPeristaltic_gm.friction(ut);

      % equation
      term1 = Q*uxx;
      term2 = forcing_data;
      term3 = R;
      term4 = mu/delt;
      term5 = friction_data;

      col = (term1 +term2 -term3*(-2*prev1+prev2) +term4.*prev1 -term5)/(P/delt^2+mu/delt);
    end
    
  end
end