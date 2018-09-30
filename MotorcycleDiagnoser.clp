; Entry node(s) 
; Modified from tutorial recording 8 Douglas, G. (2018). Introduction to CLIPS. retrieved from https://mediastore.auckland.ac.nz/2018/1185/COMPSCI367T01C/1023055/c23eca/201809281400.LT347637.preview
(defrule start-motorcycle =>
	(printout t "Did you attempt to start the motorcycle after turning the ignition to on using the ignition switch or kick-starter? 0=switch 1=kick-starter" crlf)
	(bind ?start-motorcycle-with (read))
)