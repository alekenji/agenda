class Api::SchedulesController < ApplicationController

  def create

    tasks = params[:task]
    task  = tasks.split('||')
    
    agenda = rebuildTask(task) # { task: xxxxx, hours: 99:99, time: 99999, order: 99 } 

    list = buildAgenda( agenda )

    render :json => list

  end

  def index    
    render :json => 'OK'
  end


  def buildAgenda( tasks )

    result = Array.new
    waitTimeZero = Array.new
    stepStartHours = 540 
    stepEndHours = 720
    continueLoop = true
    loopOk = true

    tasks.each_with_index do |tk, key|

      if ( tk["checked"] == 9 )
          waitTimeZero.push(tk)
      end

    end

    while continueLoop do 

        tasks.each_with_index do |tk, key|

          if ( tk["checked"] == 1 ) 

              time = stepStartHours + tk["time"].to_i
            
              if ( time >= stepStartHours && time <= stepEndHours )

                  hours = transformarHorasMinutos( stepStartHours )                  
                  result.push( "task"=> tk["task"], "hours" => hours, "time" => tk["time"], "order" => key )
                  tasks[key]["checked"] = 0
                  stepStartHours = time          

              end

          end 

        end #each

        if ( loopOk == true ) 

            if ( (stepEndHours - stepStartHours) > 0 ) 

              if ( waitTimeZero.length > 0 ) 
                
                waitTimeZero.each_with_index do |wtk, key|

                  if ( wtk["checked"] == 9 ) 

                      hours = transformarHorasMinutos( stepStartHours )
                      result.push( "task"=> wtk["task"], "hours" => hours, "time" => 0, "order" => 99 )
                      waitTimeZero[key]["checked"] = 0

                  end

                end #each

              end #if

            end #if

            loopOk = false
            stepStartHours = 780
            stepEndHours = 1020       

      else

        if ( (stepEndHours - stepStartHours) > 0 ) 

            if ( waitTimeZero.length > 0 ) 
              
                waitTimeZero.each_with_index do |wtk, key|

                  if ( wtk["checked"] == 9 )  
                      hours = transformarHorasMinutos( stepStartHours )
                      result.push( "task"=> wtk["task"], "hours" => hours, "time" => 0, "order" => 99 )
                      waitTimeZero[key]["checked"] = 0
                  end 

                end #each

            end #if

        end #if

        continueLoop = false 

      end #if 
          
    end # while

    result

  end


  def rebuildTask( tasks )

    if ( tasks.length > 0 || tasks != nil ) 
    
      result = Array.new     

      tasks.each_with_index do |tk, key|

          task = tk
          hour = '00:00'
          time = 0
          checked = 1

          hours = tk.scan(/ \d+ minutos/).first

          if ( hours ) 
            hoursSplit = hours.split(' ')
            time = hoursSplit[0]
            hour = transformarHorasMinutos(hoursSplit[0])
            string = tk.split(hours)  
            task = string[0]    
          end 

          if ( time == 0 )
             checked = 9 
          end

          result.push( "task"=> task, "hours" => hour, "time" => time, "order" => key, "checked" => checked )        

      end # each

      result

    end #if 

  end  


  def transformarHorasMinutos( valor )

    horas = valor.to_i/60
    minutos = valor.to_i%60

    if (minutos > 0) 
      stringMinutos = minutos.to_s
      if ( stringMinutos.length == 1 )
        stringMinutos = '0'+stringMinutos
      end
    else
      stringMinutos = '00'  
    end 

    stringHoras = horas.to_s
    if ( stringHoras.length == 1)
      stringHoras = '0'+stringHoras 
    end

    stringHoras+':'+stringMinutos

  end

end
