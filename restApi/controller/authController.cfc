<cfcomponent rest="true" restpath="auth">

    <cffunction name="login" restpath="login" access="remote" returntype="struct" httpmethod="POST" produces="application/json">
        <cfargument name="userDetails" type="struct" required="yes"/>
  
        <cfset local.loginObj = {}>
        <cfif arguments.userDetails.username eq "admin" AND arguments.userDetails.password eq "password">
            <cfset local.expdt =  dateAdd("n", 30, now())>
            <cfset local.utcDate = dateDiff('s', dateConvert('utc2Local', createDateTime(1970, 1, 1, 0, 0, 0)), local.expdt) />
            <cfset local.payload = {"iss" = "restdemo", "exp" = local.utcDate, "sub": "JWT Token"}>
            <cfset local.token = application.jwtServices.encode(local.payload)>
  
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
    
</cfcomponent>