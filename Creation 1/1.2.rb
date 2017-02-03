use_bpm 123

/ DEFINE /
##| electro_bass_soft = "D:/Users/G602857/Documents/Perso/SonicPi/samples/electro_bass_soft.wav"
##| woodclick_high = "D:/Users/G602857/Documents/Perso/SonicPi/samples/woodclick_high.wav"
##| woodclick_low = "D:/Users/G602857/Documents/Perso/SonicPi/samples/woodclick_low.wav"
##| tambourine_up = "D:/Users/G602857/Documents/Perso/SonicPi/samples/tambourine_up.wav"
##| shaker_long = "D:/Users/G602857/Documents/Perso/SonicPi/samples/shaker_long.wav"
##| shaker_short = "D:/Users/G602857/Documents/Perso/SonicPi/samples/shaker_short.wav"
##| slapstick = "D:/Users/G602857/Documents/Perso/SonicPi/samples/slapstick.wav"
##| claves = "D:/Users/G602857/Documents/Perso/SonicPi/samples/claves.wav"

electro_bass_soft = "C:/Users/alexa/Music/SonicPi/sample/electro_bass_soft.wav"
woodclick_high = "C:/Users/alexa/Music/SonicPi/sample/woodclick_high.wav"
woodclick_low = "C:/Users/alexa/Music/SonicPi/sample/woodclick_low.wav"
tambourine_up = "C:/Users/alexa/Music/SonicPi/sample/tambourine_up.wav"
shaker_long = "C:/Users/alexa/Music/SonicPi/sample/shaker_long.wav"
shaker_short = "C:/Users/alexa/Music/SonicPi/sample/shaker_short.wav"
slapstick = "C:/Users/alexa/Music/SonicPi/sample/slapstick.wav"
claves = "C:/Users/alexa/Music/SonicPi/sample/claves.wav"

/------------------------------------------------------------------------------------------------------------/

in_thread(name: :music) do
  
  / LIVE CONTROL /
  ring1 = (ring 4,0.5,2.25,0.5,0.25,0.5)
  chord1 = (ring :D3,:C3,:D3,:A3,:G3,:F3)
  
  ring2 = (ring 1,3)
  chord2 = (ring :D4,:A4,:C4,:G4)
  
  ##| ring2 = (ring 1,1,1,1)
  ##| chord2 = (ring :D4,:A4,1,:D5,:C4,:G4,1,:C5)
  
  ##| ring2 = (ring 1,1,1,1)
  ##| chord2 = (ring :D4,:A4,:E4+1,:D5,:C4,:G4,:E4,:C5)
  
  sustain1=(ring 3.5,1,2.25,1,0.7,0.7)
  
  live_loop :melody1 do
    cue :melody
    
    6.times do
      use_synth :fm
      note_actual = chord1.tick(:t1)
      sustain_actual = sustain1.tick(:t2)
      /----------------------------------------------/
      AMP1 = 0
      play note_actual+0, sustain:sustain_actual,amp: AMP1
      play note_actual+12, sustain:sustain_actual, amp: AMP1
      play note_actual+24, sustain:sustain_actual, amp: AMP1
      sample :drum_bass_soft, sustain:1, amp: AMP1
      /-----------------------------------------------/
      sleep ring1.tick(:t3)
    end
  end
  
  live_loop :melody3 do
    sync :melody
    
    use_synth :saw
    8.times do
      /---------------------------/
      AMP2 = 0
      SUST = 0.5
      /---------------------------/
      play chord2.tick(:t4), amp: AMP2, sustain: SUST
      sleep ring2.tick(:t5)
    end
  end
  
  live_loop :x do
    sync :melody
    use_synth :dark_ambience
    /-------------------------------/
    AMP3 =0
    NOTE1 = :A3
    # A3, C4, F3
    /-------------------------------/
    play NOTE1, sustain:8, amp:AMP3
    play NOTE1+12, sustain:8, amp:AMP3
    sleep 1
  end
end

/------------------------------------------------------------------------------------------------------------/

in_thread(name: :drum) do
  /------------------------------------/
  kick_ok=0
  /------------------------------------/
  
  live_loop :syncrhonised do
    /-----------------------------------/
    AMP5 = 0
    /-----------------------------------/
    sync :melody
    cue :half_melody
    sleep 4
    cue :half_melody
    sleep 4
  end
  
  live_loop :kick do
    sync :half_melody
    if kick_ok==1
      2.times do
        cue :rythm
        sample electro_bass_soft, amp:1.5*AMP5, sustain:0.7
        sleep 1
        sample electro_bass_soft, amp:AMP5, sustain:0.7
        sleep 1
      end
    else
      cue :rythm
      sleep 4
    end
  end
  
  live_loop :snare do
    sync :rythm
    if kick_ok==1
      sleep 1
      sample :drum_snare_soft, amp:AMP5, sustain:1
      sample :perc_snap, amp:AMP5
      sleep 2
      sample :drum_snare_soft, amp:AMP5, sustain:1
      sleep 1
    else
      sleep 4
    end
  end
  
  live_loop :closed_hi_hat do
    sync :rythm
    4.times do
      sleep 0.5
      sample  :drum_cymbal_closed, amp:AMP5
      sleep 0.5
    end
  end
  
  live_loop :opened_hi_hat do
    sync :rythm
    if kick_ok==1
      sleep 2.5
      sample  :elec_cymbal, sustain:0.2, amp:AMP5
      sleep 1.5
    else
      sleep 4
    end
  end
end

/------------------------------------------------------------------------------------------------------------/

in_thread(name: :rythm2) do
  
  ring3 = (ring 0.5,0.5,0.5,0.25,0.25,0.25,0.25,0.5,0.25,0.25,0.25,0.25)
  
  live_loop :x1 do
    sync :half_melody
    cue :sync
    /-------------------------------------/
    AMP4 = 0
    /-------------------------------------/
    12.times do
      sample woodclick_high, amp:AMP4*3
      sleep ring3.tick(:t4)
    end
  end
  
  live_loop :x2 do
    sync :sync
    sleep 1.5
    sample tambourine_up, amp:AMP4*2
    sleep 0.5
    sample tambourine_up, amp:AMP4*2
    sleep 1
    sample tambourine_up, amp:AMP4*2
    sleep 1
  end
  
  live_loop :x3 do
    sync :sync
    8.times do
      sleep 0.5
      sample claves, amp:AMP4
      sample slapstick, amp:AMP4
      sample shaker_short, amp:AMP4*2
      sleep 0.5
    end
  end
  
  live_loop :x4 do
    sync :sync
    4.times do
      sleep 1
      sample shaker_long, amp:AMP4*2
      sleep 1
    end
  end
end
