(deftemplate start-status "Store the variable that the user answers with when trying to start their engine"
   (slot value (type INTEGER) (range 0 2))
)

(deftemplate engine-status "Store the variable that the user answers with when trying to start their engine"
   (slot value (type INTEGER) (range 0 3))
)

(deftemplate dash-lights "Engine does not start & battery is not flat. this template will store which lights are on (represented in integers)"
   (slot value (type INTEGER) (range 0 3))
)

(deftemplate engine-noises "Frequency of the noises the engine makes when idle"
   (slot value (type INTEGER) (range 0 2))
)

(deftemplate performance "How the motorcycle performs while on the road"
   (slot value (type INTEGER) (range 0 3))
)

(deftemplate oil-level "The oil level on the spy glass"
   (slot value (type INTEGER) (range 0 3))
)

(deftemplate frequency-oiled "how often the motorcycle chain is oiled"
   (slot value (type INTEGER) (range 0 2))
)

(deftemplate saw-tooth-pattern "how often the motorcycle chain is oiled"
   (slot value (type INTEGER) (range 0 2))
)

; Entry node(s) 
; Modified from tutorial recording 8 Douglas, G. (2018). Introduction to CLIPS. retrieved from https://mediastore.auckland.ac.nz/2018/1185/COMPSCI367T01C/1023055/c23eca/201809281400.LT347637.preview
; Additional resource used and modified from tutorial 8 slides Douglas, G. (2018). Introduction to CLIPS. retrieved from https://canvas.auckland.ac.nz/courses/29972/files/folder/Tutorials?preview=2512832
(defrule start-motorcycle =>
	(printout t "Did you attempt to start the motorcycle after turning the ignition to on using the ignition switch or kick-starter? 1=switch 2=kick-starter" crlf)
	(bind ?response (read))
	(if	(or (= ?response 1) (= ?response 2))
	 then	(assert(start-status (value ?response)))
     else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
	)
)

; get information to determine what parts of the motorcycle has failed upon startup
(defrule does-it-start (start-status) =>
	(printout t "Does it start? 1=No, headlights off & engine failed to ignite 2=No, headlights on & engine failed to ignite 3=Yes, (headlights on & engine on)" crlf)
	(bind ?response (read))
	(if	(or (or (= ?response 1) (= ?response 2)) (= ?response 3))
	 then	(assert(engine-status (value ?response)))
     else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
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
			else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)

; if the engine light is on then it entered the "engine overheated" exit state
; if the engine light is on then it entered the "engine overheated" exit state
(defrule engine-light-on (dash-lights (value ?dash-light)) =>
	(if	(= ?dash-light 3)
	 then	
		(printout t "The engine is overheated. Please wait for it to cool down" crlf)
	)
)

; if the fuel light is on then it entered the "refuel" exit state
(defrule reserves-light-on (dash-lights (value ?dash-light)) =>
	(if	(= ?dash-light 2)
	 then	
		(printout t "The fuel tank cannot be empty when starting the engine. Please refuel until reserve/fuel light turns off" crlf)
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
			else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
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

; asks the user how the engine performs on the road
(defrule performance-on-road (engine-noises (value ?engine-noise)) =>
	(if	(= ?engine-noise 1)
	 then	
		(printout t "When riding the motorcycle on the road, how does the bike perform? 1=smooth acceleration and deceleration 2=sudden and intermittent acceleration and deceleration 3=smooth acceleration but heavy drop in engine noise when decelerating" crlf)
		(bind ?response (read))
		(if	(or (or (= ?response 1) (= ?response 2)) (= ?response 3))
			then	(assert(performance (value ?response)))
			else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)

; enters the "all checks passed" exit state
(defrule all-checks-passed (performance (value ?status)) =>
	(if	(= ?status 1)
	 then	
		(printout t "All checks completed, motorcycle is behaving normally" crlf)
	)
)

; asks the user to check the oil level on the motorcycle's engine oil spy glass
(defrule oil-level-check (performance (value ?performance-status)) =>
	(if	(= ?performance-status 3)
	 then	
		(printout t "check the oil spy glass. Where is the oil level when the bike is a bike stand? 1=below the lower indicator 2=above the indicator 3=between the indicator" crlf)
		(bind ?response (read))
		(if	(or (or (= ?response 1) (= ?response 2)) (= ?response 3))
			then	(assert(oil-level (value ?response)))
			else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)

; if the oil level is below the indicator then there is not enough engine oil being pulled into the engine (enters "add more oil" exit state)
(defrule low-engine-oil (oil-level (value ?level)) =>
	(if	(= ?level 1)
	 then	
		(printout t "The oil level is too low and not enough oil is being pull into the engine when decelerating. Please fill the engine oil to inbetween the spy glass indicators" crlf)
	)
)

; Normal oil levels and stalling engines are a common problem in old bikes which have no EFI (enters "EFI failure" exit state)
(defrule high-normal-engine-oil (oil-level (value ?level)) =>
	(if	(or (= ?level 2) (= ?level 3))
	 then	
		(printout t "The engine wanting to stall while having normal oil levels are often a problem with old bikes which have no EFI. It is recommened that the EFI be repaired or replaced" crlf)
	)
)

; asks the user how often they oil their chains
(defrule oil-chain-frequency (performance (value ?performance-status)) =>
	(if	(= ?performance-status 2)
	 then	
		(printout t "How often are the chains oiled? 1=less than once every two months 2=greater than once every two months" crlf)
		(bind ?response (read))
		(if	(or (= ?response 1) (= ?response 2))
			then	(assert(frequency-oiled (value ?response)))
			else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)

; damage has been done to the chain (enters "replace chain" exit state)
(defrule dry-chain-damage (frequency-oiled (value ?frequency)) =>
	(if	(= ?frequency 1)
	 then	
		(printout t "The chain to too dry and may have been damanged. A replacement chain is recommened" crlf)
	)
)

; asks the user to check for saw tooth pattterns on the chain sprocket
(defrule sprocket-check (frequency-oiled (value ?frequency)) =>
	(if	(= ?frequency 2)
	 then	
		(printout t "Please check the chain sprocket teeth. Are there any saw tooth patterns? 1=Yes 2=No" crlf)
		(bind ?response (read))
		(if	(or (= ?response 1) (= ?response 2))
			then	(assert(saw-tooth-pattern (value ?response)))
			else	(printout t "Please give a valid response (ie the options provided in the question)" crlf)
		)
	)
)

; damage has been done to the chain sprocket (enters "replace chain sprocket" exit state)
(defrule sprocket-damage (saw-tooth-pattern (value ?bool)) =>
	(if	(= ?bool 1)
	 then	
		(printout t "The sprocket on the bike which delevers power to the wheels have been damaged and needs to be replaced" crlf)
	)
)

; engine is potentially faulty (enters "engine fault" exit state)
(defrule engine-faulty (saw-tooth-pattern (value ?bool)) =>
	(if	(= ?bool 2)
	 then	
		(printout t "The engine is showing signs of being faulty and needs to be taken to a full inspection" crlf)
	)
)