<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/security" prefix="liferay-security" %>
<%@ taglib uri="http://liferay.com/tld/item-selector" prefix="liferay-item-selector" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/trash" prefix="liferay-trash" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="javax.portlet.PortletPreferences" %>

<%@ page import="javax.portlet.PortletURL" %>
<%@ page import="com.liferay.portal.kernel.util.*" %>
<%@ page import="com.liferay.portal.kernel.model.*" %>
<%@ page import="com.liferay.portal.kernel.portlet.*" %>
<%@ page import="com.liferay.portal.kernel.service.*" %>
<%@ page import="com.liferay.support.tools.constants.*" %>
<%@ page import="com.liferay.asset.kernel.model.*" %>
<%@ page import="com.liferay.asset.kernel.service.*" %>

<%@ page import="com.liferay.portal.kernel.dao.orm.QueryUtil" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil" %>
<%@ page import="com.liferay.support.tools.portlet.actions.PageMVCResourceCommand" %>
<%@ page import="com.liferay.support.tools.portlet.actions.RoleMVCResourceCommand" %>
<%@ page import="com.liferay.support.tools.messageboard.MBMVCResourceCommand" %>

<%@ page import="com.liferay.support.tools.portlet.actions.DummyFactoryConfiguration" %>
<%@ page import="com.liferay.dynamic.data.mapping.model.*" %>
<%@ page import="com.liferay.journal.model.*" %>
<%@ page import="com.liferay.journal.service.*" %>
<%@ page import="com.liferay.dynamic.data.mapping.service.*" %>
<%@ page import="com.liferay.message.boards.kernel.model.*" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Locale" %>

<liferay-frontend:defineObjects/>
<liferay-theme:defineObjects/>
<portlet:defineObjects/>

<%
	PortletURL portletURL = PortletURLUtil.clone(renderResponse.createRenderURL(), liferayPortletResponse);
	String redirect = ParamUtil.getString(request, "redirect");
	//Mode
	String mode = ParamUtil.getString(request, LDFPortletKeys.MODE, LDFPortletKeys.MODE_ORGANIZAION);
%>

<aui:script use="aui-base">
//Convert bracket for Lodash template to avoid overraping jsp tag.
_.templateSettings = {
    interpolate: /\<\@\=(.+?)\@\>/gim,
    evaluate: /\<\@([\s\S]+?)\@\>/gim,
    escape: /\<\@\-(.+?)\@\>/gim
};
</aui:script>

<%
String progressId = PwdGenerator.getPassword(PwdGenerator.KEY3, 16);
%>

<%
DummyFactoryConfiguration dummyFactoryConfiguration =
        (DummyFactoryConfiguration)
            renderRequest.getAttribute(DummyFactoryConfiguration.class.getName());


    String linkList = StringPool.BLANK;
    String urlList = StringPool.BLANK;

    if (Validator.isNotNull(dummyFactoryConfiguration)) {

        linkList =
            HtmlUtil.escape(
                portletPreferences.getValue(
                    "linkList", dummyFactoryConfiguration.linkList()));
        
        urlList =
                HtmlUtil.escape(
                    portletPreferences.getValue(
                        "urlList", dummyFactoryConfiguration.urlList()));        
    }

%>