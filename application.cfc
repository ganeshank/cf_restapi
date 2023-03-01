
<cfcomponent>
	
	<cfscript>
		this.Name="api";
	</cfscript>
    
	<cffunction name="onApplicationStart">
        <cfset application.datasource = "restapi">
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