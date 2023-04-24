
<cfcomponent rest="true" restpath="routes">

    <cfobject name="orderDao" component="cfc.order"> 
    <cfobject name="authDao" component="cfc.auth">  
    
    <!--- Order related rest apis --->
    <cffunction name="orderSubmit" restpath="order" access="remote" returntype="struct" httpmethod="POST" produces="application/json">
      <cfargument name="orderDetail" type="struct" required="yes"/>

      <cfset local.verifyAuth = authDao.authenticate()>
      <cfset local.response = {}>
      <cfif local.verifyAuth.success>
        <cfset local.response = orderDao.persistOrder(arguments.orderDetail.data)>
      <cfelse>
        <cfset local.response["success"] = false>
        <cfset local.response["message"] = "Authentication is failed"> 
      </cfif>

      <cfreturn local.response>
    </cffunction>

    <cffunction name="orderStatus" restpath="orderStatus" access="remote" returntype="struct" httpmethod="GET" produces="application/json">
      <cfset local.verifyAuth = authDao.authenticate()>
      <cfset local.response = {}>
      <cfif local.verifyAuth.success>
        <cfset response = orderDao.getOrderStatus(URL.orderId)>  
      <cfelse>
        <cfset local.response["success"] = false>
        <cfset local.response["message"] = "Authentication is failed"> 
      </cfif>

      <cfreturn local.response>
    </cffunction>

    <!--- Authentication related rest api's --->
    <cffunction name="login" restpath="login" access="remote" returntype="struct" httpmethod="POST" produces="application/json">
      <cfargument name="userDetails" type="struct" required="yes"/>

      <cfset local.loginObj = {}>
      <cfif arguments.userDetails.username eq "admin" AND arguments.userDetails.password eq "password">
          <cfset local.expdt =  dateAdd("n", 30, now())>
          <cfset local.utcDate = dateDiff('s', dateConvert('utc2Local', createDateTime(1970, 1, 1, 0, 0, 0)), local.expdt) />
          <cfset local.jwt = new cfc.jwt(Application.jwtkey)>
          <cfset local.payload = {"iss" = "restdemo", "exp" = local.utcDate, "sub": "JWT Token"}>
          <cfset local.token = local.jwt.encode(local.payload)>

          <cfset local.loginObj["success"] = true>
          <cfset local.loginObj["token"] = local.token>
          <cfset local.loginObj["message"] = "User is loggedin successfully!!!"> 
      <cfelse>
          <cfset local.loginObj["success"] = false>
          <cfset local.loginObj["token"] = "">
          <cfset local.loginObj["message"] = "User credentials incorrect!!!"> 
      </cfif>      
      <cfreturn local.loginObj>
  </cffunction>

  <cffunction  name="getFile" restpath="getFile" access="remote" returntype="struct" httpmethod="GET" produces="application/json">
    <cfset local.verifyAuth = authDao.authenticate()>
    <cfset local.response = {}>
    <cfif local.verifyAuth.success>
      <cfset response = orderDao.getFile(URL.orderId)>  
    <cfelse>
      <cfset local.response["success"] = false>
      <cfset local.response["message"] = "Authentication is failed"> 
    </cfif>

    <cfreturn local.response>
  </cffunction>
  
</cfcomponent>