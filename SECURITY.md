# Security Notice

## Fixed CVE Vulnerabilities

### ✅ CVE-2024-47561 - Apache Avro (CRITICAL) - FIXED
- **Affected Version**: 1.11.3
- **Fixed Version**: 1.11.4
- **Issue**: Arbitrary Code Execution when reading Avro Data
- **Status**: **RESOLVED** - Upgraded to avro 1.11.4

## Known CVE Vulnerabilities

### ⚠️ GHSA-72hv-8253-57qq - Jackson Core (HIGH) - NO FIX AVAILABLE YET
- **Affected Versions**: All versions including 2.19.0
- **Issue**: Number Length Constraint Bypass in Async Parser Leads to Potential DoS
- **Status**: **MONITORING** - Using latest Jackson version (2.19.0), awaiting upstream fix

#### Description
The non-blocking (async) JSON parser in jackson-core bypasses the maxNumberLength constraint (default: 1000 characters) defined in StreamReadConstraints. This allows an attacker to send JSON with arbitrarily long numbers through the async parser API, leading to excessive memory allocation and potential CPU exhaustion.

#### Impact
- Memory Exhaustion: Unbounded allocation of memory in the TextBuffer
- CPU Exhaustion: O(n²) BigInteger parsing operations

#### Mitigation Recommendations
Until a patch is available:

1. **Configure StreamReadConstraints explicitly**:
   ```java
   StreamReadConstraints constraints = StreamReadConstraints.builder()
       .maxNumberLength(1000)  // Enforce limit explicitly
       .build();
   JsonFactory factory = JsonFactory.builder()
       .streamReadConstraints(constraints)
       .build();
   ```

2. **Avoid async parsers** if possible - use synchronous parsers which correctly enforce the constraint

3. **Input validation** - Implement additional validation layers for JSON inputs from untrusted sources

4. **Rate limiting** - Implement rate limiting on endpoints that parse JSON

5. **Monitor** - Watch for updates to Jackson library: https://github.com/FasterXML/jackson-core

## Vulnerability Scanning

This project was scanned for CVEs on March 20, 2026. To re-scan dependencies:

```bash
# Check for updates to dependencies with known CVEs
mvn versions:display-dependency-updates

# Force update to latest versions (review carefully)
mvn versions:use-latest-releases
```

## Reporting Security Issues

If you discover a security vulnerability in this project, please report it privately by emailing the maintainers.
