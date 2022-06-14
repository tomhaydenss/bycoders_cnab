import "../css/app.css"

import "phoenix_html";

import React from "react";
import ReactDOM from "react-dom/client";
import { ApolloClient, ApolloProvider } from "@apollo/client";
import { InMemoryCache } from "@apollo/client/cache";
import Home from "./Home";

const client = new ApolloClient({
    uri: "/api/graphql",
    cache: new InMemoryCache(),
});

const root = ReactDOM.createRoot(document.getElementById("react-app"));
root.render(
    <ApolloProvider client={client}>
        <Home />
    </ApolloProvider>
);
