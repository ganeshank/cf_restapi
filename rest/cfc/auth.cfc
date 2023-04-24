
<cfcomponent hint="Auth specific services" displayname="order"> 
  
    <cffunction name="authenticate" returntype="any"> 
        <cfset local.response = {}>
        <cfset local.requestData = GetHttpRequestData()>
        <cfif StructKeyExists( local.requestData.Headers, "authorization" )>
            <cfset local.token = GetHttpRequestData().Headers.authorization>
            <cftry>
            <cfset jwt = new cfc.jwt(Application.jwtkey)>
            <cfset local.result = jwt.decode(local.token)>
            <cfset local.response["success"] = true>
            <cfcatch type="Any">
                <cfset local.response["success"] = false>
                <cfset local.response["message"] = "Authorization token invalid">
                <cfreturn local.response>
            </cfcatch>
            </cftry>
        <cfelse>
            <cfset local.response["success"] = false>
            <cfset local.response["message"] = "Authorization token invalid or not present.">
        </cfif>
        <cfreturn local.response>
    </cffunction>
</cfcomponent>