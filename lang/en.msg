#!/usr/bin/tclsh

# Messages for base
::msgcat::mcset en startserv "Starting service."
::msgcat::mcset en loadmodule "Loading module %s."
::msgcat::mcset en loadgame "Loading game : %s."
::msgcat::mcset en loadaddon "Loadding addon for Master Bot : %s."
::msgcat::mcset en filenotexist "Impossible to load %s. File doesn't exist."

# Messages for controller
::msgcat::mcset en cont_netconn "Network connect."
::msgcat::mcset en cont_shutdown "Shutdown of services asked by %s."

# Messages for partyline
::msgcat::mcset en pl_activation "Activation of partyline on %s:%s."
::msgcat::mcset en pl_openport "Opening of partyline port : OK"
::msgcat::mcset en pl_incconn "Connexion incoming on partyline."
::msgcat::mcset en pl_activated "\00304\002PL activated :\002\003 %s > %d:%s:%d"
::msgcat::mcset en pl_close "Closing of partyline socket %s by user %s"
::msgcat::mcset en pl_help0 "Help of TCL GameService v%s"
::msgcat::mcset en pl_help1 "Partyline commands"
::msgcat::mcset en pl_help2 "Close your partyline or a given partyline"
::msgcat::mcset en pl_help3 "Print list of users on partyline"
::msgcat::mcset en pl_help4 "Reload the service"
::msgcat::mcset en pl_help5 "Kill the service"
::msgcat::mcset en pl_inpl "Connected on PL : %s"
::msgcat::mcset en pl_inplauth "Connected and authentified on PL : %s"
::msgcat::mcset en pl_rehash "Rehash by partyline : %s"
::msgcat::mcset en pl_die "Die by partyline : %s"
::msgcat::mcset en pl_auth "You are authentified !!!"
::msgcat::mcset en pl_nouth "You are not authentified. Please use .pass <password> to authentify yourself."
::msgcat::mcset en pl_loaded "PartyLine server loaded."
