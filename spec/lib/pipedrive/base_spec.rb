require 'spec_helper'

RSpec.describe ::Pipedrive::Base do
  shared_examples 'make API calls' do |api_token: nil, oauth_credentials: {}|
    let(:api_domain) { oauth_credentials[:api_domain] }
    let(:access_token) { oauth_credentials[:access_token] }
    let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

    context '#make_api_call' do
      it 'should failed no method' do
        expect { subject.make_api_call(test: 'foo') }.to raise_error('method param missing')
      end

      context 'without id' do
        it 'should call :get' do
          if api_token
            stub_request(:get, "https://api.pipedrive.com/v1/bases?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/v1/bases?api_token=#{api_token}", {}).and_call_original
          else
            stub_request(:get, "#{api_domain}/bases").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/bases", {}).and_call_original
          end

          expect(subject.make_api_call(:get))
        end

        it 'should call :post' do
          if api_token
            stub_request(:post, "https://api.pipedrive.com/v1/bases?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:post).with("/v1/bases?api_token=#{api_token}", { test: 'bar' }).and_call_original
          else
            stub_request(:post, "#{api_domain}/bases").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:post).with("/bases", { test: 'bar' }).and_call_original
          end

          expect(subject.make_api_call(:post, test: 'bar'))
        end

        it 'should call :put' do
          if api_token
            stub_request(:put, "https://api.pipedrive.com/v1/bases?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:put).with("/v1/bases?api_token=#{api_token}", { test: 'bar' }).and_call_original
          else
            stub_request(:put, "#{api_domain}/bases").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:put).with("/bases", { test: 'bar' }).and_call_original
          end

          expect(subject.make_api_call(:put, test: 'bar'))
        end

        it 'should use field_selector properly' do
          if api_token
            stub_request(:get, "https://api.pipedrive.com/v1/bases:(a,b,c)?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/v1/bases:(a,b,c)?api_token=#{api_token}", {}).and_call_original
          else
            stub_request(:get, "#{api_domain}/bases:(a,b,c)").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/bases:(a,b,c)", {}).and_call_original
          end

          expect(subject.make_api_call(:get, fields_to_select: %w(a b c)))
        end

        it 'should not use field_selector if it empty' do
          if api_token
            stub_request(:get, "https://api.pipedrive.com/v1/bases?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/v1/bases?api_token=#{api_token}", {}).and_call_original
          else
            stub_request(:get, "#{api_domain}/bases").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/bases", {}).and_call_original
          end

          expect(subject.make_api_call(:get, fields_to_select: []))
        end

        it 'should retry if Errno::ETIMEDOUT' do
          connection = subject.connection
          allow(subject).to receive(:connection).and_return(connection)

          if api_token
            stub_request(:get, "https://api.pipedrive.com/v1/bases?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            allow(connection).to receive(:get).with("/v1/bases?api_token=#{api_token}", {}).and_raise(Errno::ETIMEDOUT)
            expect(connection).to receive(:get).with("/v1/bases?api_token=#{api_token}", {}).and_call_original
          else
            stub_request(:get, "#{api_domain}/bases").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            allow(connection).to receive(:get).with("/bases", {}).and_raise(Errno::ETIMEDOUT)
            expect(connection).to receive(:get).with("/bases", {}).and_call_original
          end

          expect(subject.make_api_call(:get, fields_to_select: []))
        end
      end

      context 'with id' do
        it 'should call :get' do
          if api_token
            stub_request(:get, "https://api.pipedrive.com/v1/bases/12?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/v1/bases/12?api_token=#{api_token}", {}).and_call_original
          else
            stub_request(:get, "#{api_domain}/bases/12").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:get).with("/bases/12", {}).and_call_original
          end

          expect(subject.make_api_call(:get, 12))
        end

        it 'should call :post' do
          if api_token
            stub_request(:post, "https://api.pipedrive.com/v1/bases/13?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:post).with("/v1/bases/13?api_token=#{api_token}", { test: 'bar' }).and_call_original
          else
            stub_request(:post, "#{api_domain}/bases/13").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:post).with("/bases/13", { test: 'bar' }).and_call_original
          end

          expect(subject.make_api_call(:post, 13, test: 'bar'))
        end

        it 'should call :put' do
          if api_token
            stub_request(:put, "https://api.pipedrive.com/v1/bases/14?api_token=#{api_token}").to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:put).with("/v1/bases/14?api_token=#{api_token}", { test: 'bar' }).and_call_original
          else
            stub_request(:put, "#{api_domain}/bases/14").with(headers: headers).to_return(:status => 200, :body => {}.to_json, :headers => {})
            expect_any_instance_of(::Faraday::Connection).to receive(:put).with("/bases/14", { test: 'bar' }).and_call_original
          end

          expect(subject.make_api_call(:put, 14, test: 'bar'))
        end
      end

      it 'should call Hashie::Mash if return empty string' do
        if api_token
          stub_request(:get, "https://api.pipedrive.com/v1/bases?api_token=#{api_token}").to_return(:status => 200, :body => '', :headers => {})
        else
          stub_request(:get, "#{api_domain}/bases").with(headers: headers).to_return(:status => 200, :body => '', :headers => {})
        end

          expect(::Hashie::Mash).to receive(:new).with(success: true).and_call_original
        expect(subject.make_api_call(:get))
      end

      it 'should call #failed_response if failed status' do
        if api_token
          stub_request(:get, "https://api.pipedrive.com/v1/bases?api_token=#{api_token}").to_return(:status => 400, :body => '', :headers => {})
        else
          stub_request(:get, "#{api_domain}/bases").with(headers: headers).to_return(:status => 400, :body => '', :headers => {})
        end

        expect(subject).to receive(:failed_response)
        expect(subject.make_api_call(:get))
      end
    end
  end

  context 'when using api_token' do
    subject { described_class.new(api_token: 'token') }

    context '#entity_name' do
      subject { super().entity_name }
      it { is_expected.to eq described_class.name.split('::')[-1].downcase.pluralize }
    end

    context '::faraday_options' do
      subject { described_class.new(api_token: 'token').faraday_options }
      it { is_expected.to eq({
        url:     'https://api.pipedrive.com',
        headers: { accept: 'application/json', user_agent: 'Pipedrive Ruby Client v1.0.0' }
      }) }
    end

    context '::connection' do
      subject { super().connection }
      it { is_expected.to be_kind_of(::Faraday::Connection) }
    end

    context '#failed_response' do
      let(:res) { double('res', body: ::Hashie::Mash.new({}), status: status) }
      subject { super().failed_response(res) }
      context 'status is 401' do
        let(:status) { 401 }
        it { is_expected.to eq(::Hashie::Mash.new({
                                                    failed:         false,
                                                    not_authorized: true,
                                                    success:        false
                                                  })) }
      end
      context 'status is 420' do
        let(:status) { 420 }
        it { is_expected.to eq(::Hashie::Mash.new({
                                                    failed:         true,
                                                    not_authorized: false,
                                                    success:        false
                                                  })) }
      end
      context 'status is 400' do
        let(:status) { 400 }
        it { is_expected.to eq(::Hashie::Mash.new({
                                                    failed:         false,
                                                    not_authorized: false,
                                                    success:        false
                                                  })) }
      end
    end

    include_examples('make API calls', api_token: 'token')
  end

  context 'when using oauth_credentials' do
    let(:subject) { described_class.new(oauth_credentials: oauth_credentials) }

    context 'when access_token is missing' do
      let(:oauth_credentials) { { api_domain: 'https://company-domain.pipedrive.com' } }
      it 'throws error' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end

    context 'when api_domain is missing' do
      let(:oauth_credentials) { { access_token: 'access-token' } }
      it 'throws error' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end

    let(:oauth_credentials) { { access_token: 'access-token', api_domain: 'https://company-domain.pipedrive.com' } }
    include_examples(
      'make API calls',
      oauth_credentials: { access_token: 'access-token', api_domain: 'https://company-domain.pipedrive.com' }
    )
  end
end
