package v1

import (
	"context"
	"net/http"
	"time"

	"golang.org/x/oauth2"
)

func WithHeaders(client *http.Client, headers map[string]string) *http.Client {
	transport := client.Transport
	return &http.Client{
		Transport: RoundTripFunc(func(req *http.Request) (*http.Response, error) {
			for key, value := range headers {
				req.Header.Add(key, value)
			}
			return transport.RoundTrip(req)
		}),
	}
}

// RoundTripFunc is a helper to create a custom RoundTripper
type RoundTripFunc func(req *http.Request) (*http.Response, error)

// RoundTrip implements the RoundTripper interface
func (f RoundTripFunc) RoundTrip(req *http.Request) (*http.Response, error) {
	return f(req)
}

func NewAuthHTTPClient(serverURL, authURL, clientID, initialToken, initialRefreshToken, devgraphEnvironment string) (*http.Client, error) {
	conf := &oauth2.Config{
		ClientID: clientID,
		Endpoint: oauth2.Endpoint{TokenURL: authURL},
	}
	token := &oauth2.Token{
		AccessToken:  initialToken,
		RefreshToken: initialRefreshToken,
		Expiry:       time.Now().Add(1 * time.Hour), // Set initial expiry
	}
	tokenSource := conf.TokenSource(context.Background(), token)
	httpClient := oauth2.NewClient(context.Background(), tokenSource)

	if devgraphEnvironment != "" {
		headers := map[string]string{
			"Devgraph-Environment": devgraphEnvironment,
		}
		httpClient = WithHeaders(httpClient, headers)
	}

	return httpClient, nil
}

func NewAuthClient(serverURL, authURL, clientID, initialToken, initialRefreshToken, devgraphEnvironment string) (*ClientWithResponses, error) {
	httpClient, err := NewAuthHTTPClient(serverURL, authURL, clientID, initialToken, initialRefreshToken, devgraphEnvironment)
	if err != nil {
		return nil, err
	}
	client, err := NewClientWithResponses(serverURL, WithHTTPClient(httpClient))
	if err != nil {
		return nil, err
	}
	return client, nil
}
