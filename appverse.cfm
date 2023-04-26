<!--- Services/cfc related cfc's are here --->

<cfset application.jwtServices = new services.jwt(application.jwtKey)>
<cfset application.authServices = new services.auth()>
<cfset application.orderServices = new services.order()>
<cfset application.utilServices = new services.order()>


<!--- Model/Database related cfc's here --->

<cfset application.orderDao = new models.orderDao(application.datasource)>