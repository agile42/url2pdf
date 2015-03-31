require 'url2pdf'

describe "Url2pdf" do

  describe "client pdf from url" do
    let(:api_key) { "123abc" }
    let(:options) { {} }

    subject { Url2pdf::Client.new(api_key, options) }

    before(:each) do
      allow(HTTParty).to receive(:get)
    end

    it 'appends api_key to the url supplied' do
      subject.pdf_from_url('http://a.url')
      expect(HTTParty).to have_received(:get).with(/#{api_key}/, anything)
    end

    it 'escapes the url and params supplied so that it can be properly passed to the server' do
      subject.pdf_from_url('http://google.com?param=something&another=different')
      expect(HTTParty).to have_received(:get).with(/http%3A%2F%2Fgoogle.com%3Fparam%3Dsomething%26another%3Ddifferent/, anything)
    end

    it 'uses the default server unless otherwise specified' do
      subject.pdf_from_url('http://a.url')
      expect(HTTParty).to have_received(:get).with(/^#{Url2pdf::Client::DEFAULT_PDF_SERVICE_URL}/, anything)
    end

    it 'uses the default timeout unless otherwise specified' do
      subject.pdf_from_url('http://a.url')
      expect(HTTParty).to have_received(:get).with(anything, hash_including(timeout: Url2pdf::Client::DEFAULT_HTTP_TIMEOUT))
    end

    context 'different pdf server is specified in options' do
      let(:server_url) { "http://newicanhazserver.com" }
      let(:options) { {server_url: server_url} }

      it 'uses the server url supplied' do
        subject.pdf_from_url('http://a.url')
        expect(HTTParty).to have_received(:get).with(/^#{server_url}/, anything)
      end
    end

    context 'timeout is specified in options' do
      let(:timeout) { 2000 }
      let(:options) { {timeout: timeout} }

      it 'uses the http timeout supplied' do
        subject.pdf_from_url('http://a.url')
        expect(HTTParty).to have_received(:get).with(anything, hash_including(timeout: timeout))
      end
    end

    context 'no api key is supplied' do
      let(:api_key) { nil }

      it 'raises an eror' do
        expect { subject.pdf_from_url('http://a.url') }.to raise_error("API Key Is Required")
      end
    end

    describe 'pdf options supplied' do

      context 'margin' do
        it 'passes the margin parameter to the server' do
          subject.pdf_from_url('http://a.url', {margin: '5cm'})
          expect(HTTParty).to have_received(:get).with(/margin=5cm/, anything)
        end
      end

      context 'orientation' do
        it 'passes the orientation parameter to the server' do
          subject.pdf_from_url('http://a.url', {orientation: :landscape})
          expect(HTTParty).to have_received(:get).with(/orientation=landscape/, anything)
        end
      end

      context 'valid engine' do
        it 'passes the engine parameter' do
          subject.pdf_from_url('http://a.url', {engine: :phantomjs})
          expect(HTTParty).to have_received(:get).with(/engine=phantomjs/, anything)
        end
      end

    end

  end

end
