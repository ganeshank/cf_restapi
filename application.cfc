
<cfcomponent>
	
	<cfscript>
		this.Name="api";
	</cfscript>
    <cfset this.restsetting = {
        cflocation :"./",
        skipcfcerror:true
    }>
    <cfset this.mappings = structNew()>
    <cfset this.mappings["/cfc"] = expandPath("/cf_restapi/rest/cfc")>
    
	<cffunction name="onApplicationStart">
        <cfset application.datasource = "local">
        <cfset application.jwtKey = "%ng@dkdbW">
        <cfset restInitApplication(getDirectoryFromPath(getCurrentTemplatePath()) & 'rest',"controller")>
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