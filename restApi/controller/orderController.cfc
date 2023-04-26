<cfcomponent rest="true" restpath="orders">

    <cffunction name="orderSubmit" restpath="order" access="remote" returntype="struct" httpmethod="POST" produces="application/json">
        <cfargument name="orderDetail" type="struct" required="yes"/>
  
        <cfset local.verifyAuth = application.authServices.authenticate()>
        <cfset local.response = {}>
        <cfif local.verifyAuth.success>
          <cfset local.response = application.orderServices.persistOrder(arguments.orderDetail.data)>
        <cfelse>
          <cfset local.response["success"] = false>
          <cfset local.response["message"] = "Authentication is failed"> 
        </cfif>  
        <cfreturn local.response>
      </cffunction>

      <cffunction name="orderStatus" restpath="order-status" access="remote" returntype="struct" httpmethod="GET" produces="application/json">
        <cfset local.verifyAuth = application.authServices.authenticate()>
        <cfset local.response = {}>
        <cfif local.verifyAuth.success>
          <cfset response = application.orderServices.getOrderStatus(URL.orderId)>  
        <cfelse>
          <cfset local.response["success"] = false>
          <cfset local.response["message"] = "Authentication is failed"> 
        </cfif>
  
        <cfreturn local.response>
      </cffunction>

      <cffunction  name="getFile" restpath="get-file" access="remote" returntype="struct" httpmethod="GET" produces="application/json">
        <cfset local.verifyAuth =application.authServices.authenticate()>
        <cfset local.response = {}>
        <cfif local.verifyAuth.success>
          <cfset response = application.orderServices.getFile(URL.orderId)>  
        <cfelse>
          <cfset local.response["success"] = false>
          <cfset local.response["message"] = "Authentication is failed"> 
        </cfif>
    
        <cfreturn local.response>
      </cffunction>
</cfcomponent>