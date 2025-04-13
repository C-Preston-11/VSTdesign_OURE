classdef ButterworthLPF < audioPlugin
  
  %public properties (changable)
  properties        
    Cutoff = 15e3;  %initial Fc
    N = 10;
    Bypass = false; %on/off
  end
  
  %plugin customization (hidden)
  properties (Constant)
    PluginInterface = audioPluginInterface('PluginName','Butterworth LPF',...
    audioPluginParameter('Cutoff', ...
                            'Label','Hz', ...
                            'Mapping', {'log',200,20e3}, ...
                            'Style', 'rotaryknob', ...
                            'Layout', [2,2], ...
                            'DisplayName','Cutoff','DisplayNameLocation','Above'), ...
    audioPluginParameter('N', ...
                            'Label','', ...
                            'Mapping', {'int',1,20}, ...
                            'Style', 'hslider', ...
                            'Layout', [2,4], ...
                            'DisplayName','Order','DisplayNameLocation','Above'), ...    
    audioPluginParameter('Bypass', ...
                            'Style', 'vrocker', ...
                            'Layout', [4,2], ...
                            'DisplayName','Enable','DisplayNameLocation','Above'), ...                              
    audioPluginGridLayout('RowHeight',[20,200,20,120], ...                                     
                            'ColumnWidth',[20,200,20,200]));
  end

    properties (Access=private)
     init = [];     %variable order-dynamically sized coefficients
     b = [];        
     a = [];        
    end

  methods
      function out = process(obj, in)
          if obj.Bypass
            if size(obj.init, 1) ~= length(obj.a) - 1
                %reset filter state if N changes
                obj.init = zeros(length(obj.a) - 1, size(in, 2));
            end
              [out,obj.init] = filter(obj.b, obj.a, in, obj.init); %filter signal with saved filter state              
              return;
          end    
      out = in;   %no processing when bypassed         
      end
      function reset(obj)
        %init filter coefficients
        Fs = getSampleRate(obj);
        [obj.b, obj.a] = BilinearLPF(obj.Cutoff, Fs, obj.N);
        %initialize filter state based on current order
        numChannels = 2; %stereo
        obj.init = zeros(length(obj.a) - 1, numChannels);
    end

    function set.Cutoff(obj, Cutoff)
          %calculate coeff only when cutoff or N changes
      obj.Cutoff = Cutoff;
      Fs = getSampleRate(obj);
      [obj.b, obj.a] = BilinearLPF(obj.Cutoff, Fs, obj.N); 
    end
    function set.N(obj, N)
      obj.N = N;
      Fs = getSampleRate(obj);
      [obj.b, obj.a] = BilinearLPF(obj.Cutoff, Fs, obj.N)
      
    end
  end
end
