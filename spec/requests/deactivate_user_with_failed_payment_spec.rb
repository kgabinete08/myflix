require 'spec_helper'

describe "Deactivate user with failed payment" do
  let(:event_data) do
    {
      id: "evt_17QXM4GhmKibFl0dtBaJ8DfL",
      object: "event",
      api_version: "2015-10-16",
      created: 1452148480,
      data: {
        object: {
          id: "ch_17QXM4GhmKibFl0d9NNyS4Gy",
          object: "charge",
          amount: 999,
          amount_refunded: 0,
          application_fee: nil,
          balance_transaction: nil,
          captured: false,
          created: 1452148480,
          currency: "usd",
          customer: "cus_7fViHVnGDZiBBf",
          description: "Failed payment",
          destination: nil,
          dispute: nil,
          failure_code: "card_declined",
          failure_message: "Your card was declined.",
          fraud_details: {},
          invoice: nil,
          livemode: false,
          metadata: {},
          paid: false,
          receipt_email: nil,
          receipt_number: nil,
          refunded: false,
          refunds: {
            object: "list",
            data: [],
            has_more: false,
            total_count: 0,
            url: "/v1/charges/ch_17QXM4GhmKibFl0d9NNyS4Gy/refunds"
          },
          shipping: nil,
          source: {
            id: "card_17QXL6GhmKibFl0dg15DjW00",
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
            customer: "cus_7fViHVnGDZiBBf",
            cvc_check: "pass",
            dynamic_last4: nil,
            exp_month: 1,
            exp_year: 2019,
            fingerprint: "YcENpADoCG958Ywi",
            funding: "credit",
            last4: "0341",
            metadata: {},
            name: nil,
            tokenization_method: nil
          },
          statement_descriptor: "MyFlix bill",
          status: "failed"
        }
      },
      livemode: false,
      pending_webhooks: 1,
      request: "req_7ft8ZG4SRigpw7",
      type: "charge.failed"
    }
  end

  it "deactivates a user with the stripe webhook data for failed payment", :vcr do
    alice = Fabricate(:user, customer_token: "cus_7fViHVnGDZiBBf")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end
