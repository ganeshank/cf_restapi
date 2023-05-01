
<cfcomponent>
	
	<cfscript>
		this.Name="restApi";
	</cfscript>
    <cfset this.restsetting = {
        cflocation :"./",
        skipcfcerror:true,
        restEnabled = true,
		restPath = "/api"
    }>
    <cfset this.mappings = structNew()>
    <cfset this.mappings["/services"] = expandPath("/restApi/services")>
    <cfset this.mappings["/models"] = expandPath("/restApi/model")>
    
	<cffunction name="onApplicationStart">
        <cfset application.datasource = "DSNFleet">
        <cfset application.jwtKey = "%ng@dkdbW">
        <cfset restInitApplication(getDirectoryFromPath(getCurrentTemplatePath())&'restApi/controller', 'api')>
        <cfinclude  template="appverse.cfm">
        <cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart">
        <cfargument name="req" type="string" required="true"/>
  
        <cfif listLast(arguments.req,".") neq "cfc">
            <cfif isDefined("url.reload") AND url.reload gt 0>
                <cfset onApplicationStart()>
            </cfif>
        </cfif>    
    </cffunction>
	
</cfcomponent>