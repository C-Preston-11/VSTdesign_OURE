classdef BLPF < audioPlugin  
  %public properties (changable)
  properties        
    Cutoff = 15e3;  %initial Fc
    Q = 0.707; %inital resonance
    Bypass = false; %on/off
  end  
  %plugin customization (hidden)
  properties (Constant)
    PluginInterface = audioPluginInterface('PluginName','Biquad LPF',...
      audioPluginParameter('Cutoff', ...
                            'Label','Hz', ...
                            'Mapping', {'log',20,15e3}, ...
                            'Style', 'rotaryknob', ...
                            'Layout', [2,2], ...
                            'DisplayName','Cutoff','DisplayNameLocation','Above'), ...
     audioPluginParameter('Q', ...
                            'Mapping', {'lin',0.707,7}, ...
                            'Style', 'rotaryknob', ...
                            'Layout', [2,4], ...
                            'DisplayName','Resonance','DisplayNameLocation','Above'), ...
     audioPluginParameter('Bypass', ...
                            'Style', 'vrocker', ...
                            'Layout', [4,2], ...
                            'DisplayName','Enable','DisplayNameLocation','Above'), ...    
    audioPluginGridLayout('RowHeight',[20,200,20,120], ...                                     
                            'ColumnWidth',[20,200,20,200]));
  end

  properties (Access=private)
      init = zeros(2,1); %initialized filter delay state
      b = [1, zeros(1,2)];  % initialize filter
      a = [1, zeros(1,2)];
  end
  methods
      function out = process(obj, in)
          if obj.Bypass
              [out,obj.init] = filter(obj.b, obj.a, in, obj.init); %filter signal with saved filter state              
              return;
          end
      out = in;   %no processing when bypassed         
      end
      function reset(obj)
      % initialize internal state
      obj.init = zeros(2);
      Fs = getSampleRate(obj);
      [obj.b, obj.a] = BiQuadLPF(obj.Cutoff, Fs, obj.Q);
      end
      function set.Cutoff(obj, Cutoff)
          %calculate coeff only when cutoff or Q is altered
      obj.Cutoff = Cutoff;
      Fs = getSampleRate(obj);
      [obj.b, obj.a] = BiQuadLPF(obj.Cutoff, Fs, obj.Q); 
      end
      function set.Q(obj, Q)
      obj.Q = Q;
      Fs = getSampleRate(obj);
      [obj.b,obj.a] = BiQuadLPF(obj.Cutoff,Fs,obj.Q);
    end
  end
end

