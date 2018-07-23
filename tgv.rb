require 'watir' # Crawler
require 'watir-scroll'


range = 3
valid = "non"


email = 'constantinlaurent@hotmail.fr'
password = 'eDA2XStv23sz'
start = 'Paris'
arrival = 'Rennes'
date = '27/07/2018'
hour = '17'

while valid == "non"
	browser = Watir::Browser.new :chrome, switches: ['--incognito']
	browser.goto "https://www.oui.sncf/espaceclient/identification"
	valid ="non"

	#Log in mail
	puts "Logging in..."
	browser.text_field(:id => "email").set "#{email}"

	# Click Next Button
	browser.button(:id => "sncfConnectNext").click
	sleep(1)

	#Log in KEY
	puts "Set the Key ... "
	browser.text_field(:id => "password").set "#{password}"

	# Click Next Button
	browser.element(:id => "signIn").click
	sleep(2)

	# Reservation Page
	browser.goto "https://www.oui.sncf/billet-train"

	#Start
	puts "From ... "
	browser.text_field(:id => "ORIGIN_CITY").set "#{start}"

	#Destination
	puts "To ... "
	browser.text_field(:id => "DESTINATION_CITY").set "#{arrival}"

	#Date
	puts "Date ... "
	browser.text_field(:id => "OUTWARD_DATE").set "#{date}"

	#Hour
	puts "Hour ..."
	browser.select_list(:id, "OUTWARD_TIME").select("17h")

	#Lets SEARCH 
	print "Lets Search"
	browser.send_keys :enter
	sleep(8)

	# Click Close Button
	print "Next"
	browser.element(:id => "Calque_1").click

	# Click Next Train Button
	print "Next"
	browser.element(:class => "next-btn").click
	puts browser.element(:class => "complex-price ng-scope lowest complex-price__integer").text.strip


	# Validation du TGVMAX
	print "Validation TGV"
	browser.element(:class => "tgv-max-pill__TGV").click
	sleep(1)

	# Validation du prix
	print " validation price"
	browser.element(class: ["btn-validate"]).click
	sleep(6)

	url = browser.url

	if url.include? "RESERVATION_HC_THRESHOLD_REACHED"
	   browser.close
	   puts "Trop de Réservations : TGV MAX plein"
	end

	if url.include? "RESERVATION_HC_DUPLICATE_TRAVEL"
	   browser.close
	   puts "Déja une réservation sur ce Trajet"
	end



	# Validation du panier
	print "valiation panier"
	browser.element.(:id => "cartValidate").click
	sleep(6)


	#ET JE VALIDE
	print "final validation"
	browser.button(:class => "oui-button").click
	sleep(6)

	valid = "oui"

	puts "Date : "
	puts browser.element(:class => "TravelSummary-date").text

	puts "Heure : "
	puts browser.element(:class => "TravelSummary-hours").text

	puts "Trajet de ... "
	puts browser.element(:class => "OriginDestination-origin").text

	puts "à ... : "
	puts browser.element(:class => "OriginDestination-destination").text

	puts "Référence : "
	puts browser.element(class: ["List-item reference ng-scope"]).text

	sleep(5)

	browser.close
end

puts 'fin'
puts valid
