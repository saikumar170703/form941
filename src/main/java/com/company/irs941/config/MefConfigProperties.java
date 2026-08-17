package com.company.irs941.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Spring Component holding IRS MeF Transmission Configuration Properties
 * Contains EFIN, ETIN, DGVR PIN, Software ID, MeF Endpoints, and Schema versions.
 * Loaded from classpath:irs-mef.properties.
 */
@Component
public class MefConfigProperties {

    // Credentials & Identifiers
    @Value("${irs.mef.efin:10-1234}")
    private String efin;

    @Value("${irs.mef.etin:12345}")
    private String etin;

    @Value("${irs.mef.dgvrPin:54321}")
    private String dgvrPin;

    @Value("${irs.mef.softwareId:SW941APP2026}")
    private String softwareId;

    @Value("${irs.mef.returnVersion:2026v4.0}")
    private String returnVersion;

    @Value("${irs.mef.formVersion:2026v1.0}")
    private String formVersion;

    @Value("${irs.mef.namespace:http://www.irs.gov/efile}")
    private String namespace;

    // Endpoints & Environment
    @Value("${irs.mef.useProduction:false}")
    private boolean useProduction;

    @Value("${irs.mef.endpoint.ats:https://mefats.irs.gov/mefv2/services/MefSubmissionService}")
    private String atsEndpoint;

    @Value("${irs.mef.endpoint.production:https://mef.irs.gov/mefv2/services/MefSubmissionService}")
    private String productionEndpoint;

    public MefConfigProperties() {}

    // Getters and Setters
    public String getEfin() { return efin; }
    public void setEfin(String efin) { this.efin = efin; }

    public String getEtin() { return etin; }
    public void setEtin(String etin) { this.etin = etin; }

    public String getDgvrPin() { return dgvrPin; }
    public void setDgvrPin(String dgvrPin) { this.dgvrPin = dgvrPin; }

    public String getSoftwareId() { return softwareId; }
    public void setSoftwareId(String softwareId) { this.softwareId = softwareId; }

    public String getReturnVersion() { return returnVersion; }
    public void setReturnVersion(String returnVersion) { this.returnVersion = returnVersion; }

    public String getFormVersion() { return formVersion; }
    public void setFormVersion(String formVersion) { this.formVersion = formVersion; }

    public String getNamespace() { return namespace; }
    public void setNamespace(String namespace) { this.namespace = namespace; }

    public boolean isUseProduction() { return useProduction; }
    public void setUseProduction(boolean useProduction) { this.useProduction = useProduction; }

    public String getAtsEndpoint() { return atsEndpoint; }
    public void setAtsEndpoint(String atsEndpoint) { this.atsEndpoint = atsEndpoint; }

    public String getProductionEndpoint() { return productionEndpoint; }
    public void setProductionEndpoint(String productionEndpoint) { this.productionEndpoint = productionEndpoint; }
}
