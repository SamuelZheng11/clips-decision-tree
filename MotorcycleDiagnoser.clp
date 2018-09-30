(deftemplate start-status "store the variable that the user answers with when trying to start their engine"
   (slot value (type INTEGER) (range 0 2))
)

(deftemplate engine-status "store the variable that the user answers with when trying to start their engine"
   (slot value (type INTEGER) (range 0 3))
)

(deftemplate dash-lights "engine does not start & battery is not flat. this template will store which lights are on (represented in integers)"
   (slot value (type INTEGER) (range 0 3))
)

(deftemplate engine-noises "engine does not start & battery is not flat. this template will store which lights are on (represented in integers)"
   (slot value (type INTEGER) (range 0 2))
)

(deftemplate performance "engine does not start & battery is not flat. this template will store which lights are on (represented in integers)"
   (slot value (type INTEGER) (range 0 3))
)

; Entry node(s) 
; Modified from tutorial recording 8 Douglas, G. (2018). Introduction to CLIPS. retrieved from https://mediastore.auckland.ac.nz/2018/1185/COMPSCI367T01C/1023055/c23eca/201809281400.LT347637.preview
; Additional resource used and modified from tutorial 8 slides Douglas, G. (2018). Introduction to CLIPS. retrieved from https://canvas.auckland.ac.nz/courses/29972/files/folder/Tutorials?preview=2512832
(defrule start-motorcycle =>
	(printout t "Did you attempt to start the motorcycle after turning the ignition to on using the ignition switch or kick-starter? 1=switch 2=kick-starter" crlf)
	(bind ?response (read))
	(if	(or (= ?response 1) (= ?response 2))
	 then	(assert(start-status (value ?response)))
     else	(printout t "please give a valid response (ie the options provided in the question)" crlf)
	)
)

; get information to determine what parts of the motorcycle has failed upon startup
(defrule does-it-start (start-status) =>
	(printout t "Does it start? 1=No, headlights off & engine failed to ignite 2=No, headlights on & engine failed to ignite 3=Yes, (headlights on & engine on)" crlf)
	(bind ?response (read))
	(if	(or (or (= ?response 1) (= ?response 2)) (= ?response 3))
	 then	(assert(engine-status (value ?response)))
     else	(printout t "please give a valid response (ie the options provided in the question)" crlf)
	)
)

; exit node representing that the battery is flat
(defrule is-battery-flat (engine-status (value ?engine-status-value)) =>
	(if	(= ?engine-status-value 1)
	 then	(printout t "The battery in the motorcycle is flat. it needs to be recharged or replaced" crlf)
	)
)

; determines which lights on the motorcycle dashboard are on when the engine does not ignite
(defrule dashboard-lights (engine-status (value ?engine-status-value)) =>
	(if	(= ?engine-status-value 2)
	 then	
		(printout t "What lights on the dashboard are displaying? 1=no neutral light 2=fuel light on 3=engine light is on" crlf)
		(bind ?response (read))
		(if	(or (or (= ?response 1) (= ?response 2)) (= ?response 3))
			then	(assert(dash-lights (value ?response)))
			else	(printout t "please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)

; if the engine light is on then it entered the "engine overheated" exit state
(defrule engine-light-on (dash-lights (value ?dash-light)) =>
	(if	(= ?dash-light 3)
	 then	
		(printout t "The engine is overheated, please wait for it to cool down" crlf)
	)
)

; if the fuel light is on then it entered the "refuel" exit state
(defrule reserves-light-on (dash-lights (value ?dash-light)) =>
	(if	(= ?dash-light 2)
	 then	
		(printout t "The fuel tank cannot be empty when starting the engine, please refuel until reserve/fuel light turns off" crlf)
	)
)

; if the neutral light is off then it entered the "neutral light is off" exit state
(defrule neutral-light-off (dash-lights (value ?dash-light)) =>
	(if	(= ?dash-light 1)
	 then	
		(printout t "The bike is not in neutral gear. For safety reasons (and clutch/engine reasons) the motorcycle must be in neutral gear for the engine to ignite" crlf)
	)
)

; if the user is successful in starting their engine then the expert system asks what sounds it is making
(defrule motorcycle-noises (engine-status (value ?engine-status)) =>
	(if	(= ?engine-status 3)
	 then	
		(printout t "What sounds is the engine making? 1=regular soft & hard popping 2=irregular soft & hard popping" crlf)
		(bind ?response (read))
		(if	(or (= ?response 1) (= ?response 2))
			then	(assert(engine-noises (value ?response)))
			else	(printout t "please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)

; if the popping in the engine and tail-pipe is irregular after starting the engine the expert system enters the "EFI failure" exit state
(defrule efi-problems (engine-noises (value ?engine-noise)) =>
	(if	(= ?engine-noise 2)
	 then	
		(printout t "The EFI (electronic fuel injector) is faulty, it needs to be repaired or replaced" crlf)
	)
)

; if the popping in the engine and tail-pipe is irregular after starting the engine the expert system enters the "EFI failure" exit state
(defrule performance-on-road (engine-noises (value ?engine-noise)) =>
	(if	(= ?engine-noise 1)
	 then	
		(printout t "When riding the motorcycle on the road, how does the bike perform? 1=regular soft & hard popping 2=irregular soft & hard popping" crlf)
		(bind ?response (read))
		(if	(or (or (= ?response 1) (= ?response 2)) (= ?response 3))
			then	(assert(engine-noises (value ?response)))
			else	(printout t "please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)