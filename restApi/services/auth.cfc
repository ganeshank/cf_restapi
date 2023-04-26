<cfcomponent hint="Auth specific services" displayname="AuthService">>
    <cffunction name="authenticate" returntype="struct"> 
        <cfset local.response = {}>
        <cfset local.requestData = GetHttpRequestData()>
        <cfif StructKeyExists( local.requestData.Headers, "Authorization" )>
            <cfset local.token = GetHttpRequestData().Headers.authorization>
            <cftry>
            <cfset local.result = application.jwtServices.decode(local.token)>
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