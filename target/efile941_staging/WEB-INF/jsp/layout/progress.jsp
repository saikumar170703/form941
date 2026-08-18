<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int currentStep = 1;
    if (request.getAttribute("currentStep") != null) {
        currentStep = (Integer) request.getAttribute("currentStep");
    }
    
    int width = (currentStep - 1) * 25;
%>
<!-- Premium Wizard Progress Component -->
<div class="position-relative my-4 mx-2 mx-md-4 py-2">
    <div class="progress" style="height: 6px; background-color: #E2E8F0; border-radius: 10px; overflow: hidden;">
        <div class="progress-bar" role="progressbar" 
             style="width: <%= width %>%; background: linear-gradient(90deg, #4F46E5 0%, #2563EB 50%, #10B981 100%); transition: width 0.4s ease;" 
             aria-valuenow="<%= width %>" aria-valuemin="0" aria-valuemax="100"></div>
    </div>
    
    <% for(int i=1; i<=5; i++) { 
        boolean isCompleted = (i < currentStep);
        boolean isCurrent = (i == currentStep);
        
        String styleAttr = "";
        String btnClass = "";
        if (isCompleted) {
            btnClass = "btn-success shadow-sm";
            styleAttr = "background: linear-gradient(135deg, #10B981 0%, #059669 100%); border: none;";
        } else if (isCurrent) {
            btnClass = "btn-primary shadow";
            styleAttr = "background: linear-gradient(135deg, #4F46E5 0%, #2563EB 100%); border: none; box-shadow: 0 0 0 5px rgba(79, 70, 229, 0.2) !important; transform: translate(-50%, -50%) scale(1.15) !important;";
        } else {
            btnClass = "btn-light text-muted border";
            styleAttr = "background: #FFFFFF; border-color: #CBD5E1 !important;";
        }
        
        String btnText = isCompleted ? "✓" : String.valueOf(i);
        int leftPos = (i - 1) * 25;
    %>
    <button type="button" class="position-absolute top-50 translate-middle btn btn-sm rounded-circle d-flex align-items-center justify-content-center fw-bold <%= btnClass %>" 
            style="left: <%= leftPos %>%; width: 2.3rem; height: 2.3rem; z-index: 3; font-size: 0.9rem; transition: all 0.3s ease; <%= styleAttr %>"><%= btnText %></button>
    <% } %>
</div>
