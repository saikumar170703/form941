package com.company.irs941.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * Dedicated Spring Component holding Authorize.Net Payment Gateway Configuration Properties
 * Completely decoupled from IRS MeF e-file submission config.
 */
@Component
public class PaymentConfigProperties {

    @Value("${authorizenet.apiLoginId:API_LOGIN_ID_HERE}")
    private String apiLoginId;

    @Value("${authorizenet.transactionKey:TRANSACTION_KEY_HERE}")
    private String transactionKey;

    @Value("${authorizenet.clientKey:CLIENT_KEY_HERE}")
    private String clientKey;

    @Value("${authorizenet.environment:SANDBOX}")
    private String environment;

    @Value("${authorizenet.filingFee:19.99}")
    private BigDecimal filingFee;

    public PaymentConfigProperties() {}

    public String getApiLoginId() { return apiLoginId; }
    public void setApiLoginId(String apiLoginId) { this.apiLoginId = apiLoginId; }

    public String getTransactionKey() { return transactionKey; }
    public void setTransactionKey(String transactionKey) { this.transactionKey = transactionKey; }

    public String getClientKey() { return clientKey; }
    public void setClientKey(String clientKey) { this.clientKey = clientKey; }

    public String getEnvironment() { return environment; }
    public void setEnvironment(String environment) { this.environment = environment; }

    public BigDecimal getFilingFee() { return filingFee; }
    public void setFilingFee(BigDecimal filingFee) { this.filingFee = filingFee; }
}
