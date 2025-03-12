# Decentralized Art Provenance and Authenticity System

A blockchain-based solution for tracking and verifying the provenance, ownership, and authenticity of artwork.

## Overview

This system provides a transparent, immutable record of an artwork's lifecycle, from creation to exhibition and transfer of ownership. By leveraging blockchain technology, we create a trustless environment where artists, collectors, galleries, and authenticators can interact with confidence in the provenance and authenticity of art pieces.

## Core Components

### Artwork Registration Contract

Enables artists to register their artwork with verifiable creation metadata:
- Artwork details (title, medium, dimensions, year)
- Artist information and digital signature
- High-resolution image hash
- Creation timestamp
- Initial ownership assignment

### Ownership Transfer Contract

Manages the transfer of artwork ownership between parties:
- Records all historical owners in chronological order
- Implements secure transfer mechanisms with multi-signature requirements
- Stores transaction details including price data (optional)
- Integrates with existing marketplaces and auction houses

### Exhibition History Contract

Tracks the movement and display history of art pieces:
- Exhibition venue and duration
- Condition reports before and after exhibitions
- Transportation records
- Insurance documentation
- Exhibition-specific metadata

### Authenticity Verification Contract

Facilitates the process of confirming artwork legitimacy:
- Authentication expert verification and digital signatures
- Condition assessment records
- Technical analysis reports (material analysis, infrared imaging, etc.)
- Challenge and dispute resolution mechanisms

## Getting Started

### Prerequisites

- Node.js (v16.0+)
- Truffle or Hardhat development framework
- MetaMask or similar Web3 wallet
- IPFS node (for decentralized storage)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/art-provenance-system.git
cd art-provenance-system

# Install dependencies
npm install

# Compile smart contracts
npx truffle compile
# or
npx hardhat compile
```

### Deployment

```bash
# Deploy to testnet
npx truffle migrate --network rinkeby
# or
npx hardhat run scripts/deploy.js --network rinkeby

# Deploy to mainnet
npx truffle migrate --network mainnet
# or
npx hardhat run scripts/deploy.js --network mainnet
```

## Usage Examples

### For Artists

```javascript
// Register a new artwork
await artworkRegistrationContract.registerArtwork(
  "Starry Night", 
  "Oil on canvas", 
  "73.7 cm × 92.1 cm",
  "2023",
  "ipfs://QmXgbTyCRSzXKGbEJUg4SX8soWgFSQRVJKobjxpo8Kdj8j",
  { from: artistAddress }
);
```

### For Collectors

```javascript
// Transfer ownership
await ownershipTransferContract.transferOwnership(
  artworkId,
  newOwnerAddress,
  purchaseAmount,
  { from: currentOwnerAddress }
);
```

### For Galleries

```javascript
// Register an exhibition
await exhibitionHistoryContract.addExhibition(
  artworkId,
  "Modern Art Gallery",
  "New York",
  1672531200, // start timestamp
  1677715200, // end timestamp
  "Special Collection",
  "ipfs://QmYbTcRZMGnSj9jWxsmxQRijbKBbJLCUGZmUYb3QJxNRnD", // condition report
  { from: galleryAddress }
);
```

### For Authenticators

```javascript
// Verify artwork authenticity
await authenticityVerificationContract.verifyAuthenticity(
  artworkId,
  true, // isAuthentic
  "Confirmed original through material analysis and provenance records",
  "ipfs://QmZcULh7nXQxfYYCjvHWnrC5yxvM4yQMGzCDrXAUBKQXxL", // detailed report
  { from: authenticatorAddress }
);
```

## System Architecture

The system is built on a modular architecture with four primary smart contracts that interact with each other:

1. **ArtworkRegistration**: The foundation contract that establishes an artwork's identity
2. **OwnershipTransfer**: References the ArtworkRegistration contract to manage ownership changes
3. **ExhibitionHistory**: Records exhibition data linked to the artwork's ID
4. **AuthenticityVerification**: Provides verification mechanisms for registered artworks

All metadata and large files (images, detailed reports) are stored on IPFS with only the content hashes stored on-chain.

## Security Considerations

- Multi-signature requirements for high-value transfers
- Timelock mechanisms for disputed transfers
- Role-based access control for various functions
- Emergency pause functionality
- Thoroughly audited contracts

## Roadmap

- **Phase 1**: Core smart contract development and testing
- **Phase 2**: User interface development and integration with IPFS
- **Phase 3**: Mobile application and API development
- **Phase 4**: Integration with major marketplaces and auction houses
- **Phase 5**: Implementation of advanced features (fractional ownership, insurance integration)

## Contributing

We welcome contributions from the community. Please read our contributing guidelines before submitting a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please contact the development team at dev@artprovenancesystem.com
