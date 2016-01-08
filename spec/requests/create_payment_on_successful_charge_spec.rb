require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      id: "evt_17OiNlGhmKibFl0dUi5so1YE",
      object: "event",
      api_version: "2015-10-16",
      created: 1451714213,
      data: {
        object: {
          id: "ch_17OiNlGhmKibFl0d6gracXj0",
          object: "charge",
          amount: 999,
          amount_refunded: 0,
          application_fee: nil,
          balance_transaction: "txn_17OiNlGhmKibFl0dCsoe12vY",
          captured: true,
          created: 1451714213,
          currency: "usd",
          customer: "cus_7e0OhJ152pLwxA",
          description: nil,
          destination: nil,
          dispute: nil,
          failure_code: nil,
          failure_message: nil,
          fraud_details: {},
          invoice: "in_17OiNlGhmKibFl0dh5OS54HM",
          livemode: false,
          metadata: {},
          paid: true,
          receipt_email: nil,
          receipt_number: nil,
          refunded: false,
          refunds: {
            object: "list",
            data: [],
            has_more: false,
            total_count: 0,
            url: "/v1/charges/ch_17OiNlGhmKibFl0d6gracXj0/refunds"
          },
          shipping: nil,
          source: {
            id: "card_17OiNkGhmKibFl0dSVX1FrRK",
            object: "card",
            address_city: nil,
            address_country: nil,
            address_line1: nil,
            address_line1_check: nil,
            address_line2: nil,
            address_state: nil,
            address_zip: nil,
            address_zip_check: nil,
            brand: "Visa",
            country: "US",
            customer: "cus_7e0OhJ152pLwxA",
            cvc_check: "pass",
            dynamic_last4: nil,
            exp_month: 1,
            exp_year: 2017,
            fingerprint: "euRbtQnf6hIeXuTz",
            funding: "credit",
            last4: "4242",
            metadata: {},
        name: nil,
        tokenization_method: nil
          },
          statement_descriptor: "MyFlix Subsription",
          status: "succeeded"
        }
      },
      livemode: false,
      pending_webhooks: 1,
      request: "req_7e0OZKP83j4uz6",
      type: "charge.succeeded"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_7e0OhJ152pLwxA")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_7e0OhJ152pLwxA")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_7e0OhJ152pLwxA")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_17OiNlGhmKibFl0d6gracXj0")
  end
end
