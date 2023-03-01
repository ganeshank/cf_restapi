
<cfcomponent rest="true" restpath="routes">

    <cfobject name="orderDao" component="cfc.order">  
    
    <cffunction name="orderSubmit" restpath="order" access="remote" returntype="struct" httpmethod="POST" produces="application/json">
  
      <cfargument name="orderDetail" type="struct" required="yes"/>
      <cfset response = orderDao.persistOrder(arguments.orderDetail.data)>
  
      <cfreturn response>
    </cffunction>

    <cffunction name="orderStatus" restpath="orderStatus" access="remote" returntype="struct" httpmethod="GET" produces="application/json">
      <cfset response = orderDao.getOrderStatus(URL.orderId)>  
      <cfreturn response>
    </cffunction>
  
  </cfcomponent>