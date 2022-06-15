import React from 'react'
import Transactions from "./Transactions";

export default function CompanyTransactions({ items }) {
  if (items.length > 0) {
    return (
      <div className="company-transactions">
        <h3>Company Transaction Details</h3>
        {
          items.map((company, idx) => (
            <div key={idx} className="company">
              <div className="company-info">Company {company.tradingName} owned by {company.ownerName} with balance {company.balance}</div>
              <Transactions items={company.transactions} />
            </div>

          ))
        }
      </div>
    )
  }
}