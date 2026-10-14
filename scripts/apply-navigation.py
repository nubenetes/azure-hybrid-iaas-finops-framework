#!/usr/bin/env python3
"""
Adds consistent top breadcrumb navigation bars and bottom navigation footers
to all Markdown documentation in docs/, docs/adr/, and docs/math-models/.
"""
import os

DOCS_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'docs'))

GUIDES = [
    ("01-governance-tagging-cost-allocation.md", "01. Governance & Tagging", None, ("02-compute-rightsizing-lifecycle-spot.md", "02. Compute Rightsizing")),
    ("02-compute-rightsizing-lifecycle-spot.md", "02. Compute Rightsizing", ("01-governance-tagging-cost-allocation.md", "01. Governance & Tagging"), ("03-licensing-ahb-constrained-vcpu.md", "03. Advanced Licensing")),
    ("03-licensing-ahb-constrained-vcpu.md", "03. Advanced Licensing", ("02-compute-rightsizing-lifecycle-spot.md", "02. Compute Rightsizing"), ("04-commitment-portfolio-ri-savings-plans.md", "04. Commitment Engineering")),
    ("04-commitment-portfolio-ri-savings-plans.md", "04. Commitment Engineering", ("03-licensing-ahb-constrained-vcpu.md", "03. Advanced Licensing"), ("05-storage-optimization-premium-ssdv2.md", "05. Decoupled Storage")),
    ("05-storage-optimization-premium-ssdv2.md", "05. Decoupled Storage", ("04-commitment-portfolio-ri-savings-plans.md", "04. Commitment Engineering"), ("06-hybrid-network-expressroute-firewall-endpoints.md", "06. Hybrid Networking")),
    ("06-hybrid-network-expressroute-firewall-endpoints.md", "06. Hybrid Networking", ("05-storage-optimization-premium-ssdv2.md", "05. Decoupled Storage"), ("07-observability-ama-dcr-log-analytics.md", "07. Observability Containment")),
    ("07-observability-ama-dcr-log-analytics.md", "07. Observability Containment", ("06-hybrid-network-expressroute-firewall-endpoints.md", "06. Hybrid Networking"), ("08-anti-patterns-and-gotchas.md", "08. Anti-Patterns & Gotchas")),
    ("08-anti-patterns-and-gotchas.md", "08. Anti-Patterns & Gotchas", ("07-observability-ama-dcr-log-analytics.md", "07. Observability Containment"), ("09-finops-tooling-ecosystem-2026.md", "09. FinOps Tooling (2026)")),
    ("09-finops-tooling-ecosystem-2026.md", "09. FinOps Tooling (2026)", ("08-anti-patterns-and-gotchas.md", "08. Anti-Patterns & Gotchas"), ("10-audit-optimization-playbook-step-by-step.md", "10. Audit Playbook")),
    ("10-audit-optimization-playbook-step-by-step.md", "10. Audit Playbook", ("09-finops-tooling-ecosystem-2026.md", "09. FinOps Tooling (2026)"), ("11-enterprise-roadmap-calendar-milestones.md", "11. Enterprise Roadmap")),
    ("11-enterprise-roadmap-calendar-milestones.md", "11. Enterprise Roadmap", ("10-audit-optimization-playbook-step-by-step.md", "10. Audit Playbook"), ("12-legacy-architecture-governance-results.md", "12. Legacy Results")),
    ("12-legacy-architecture-governance-results.md", "12. Legacy Results", ("11-enterprise-roadmap-calendar-milestones.md", "11. Enterprise Roadmap"), ("13-advanced-finops-mastery-guide.md", "13. Advanced FinOps Blueprint")),
    ("13-advanced-finops-mastery-guide.md", "13. Advanced FinOps Blueprint", ("12-legacy-architecture-governance-results.md", "12. Legacy Results"), ("adr/README.md", "Architecture Decision Records")),
]

ADRS = [
    ("ADR-001-constrained-vcpu-for-sql-workloads.md", "ADR-001: Constrained vCPU", None, ("ADR-002-premium-ssd-v2-decoupled-storage.md", "ADR-002: Premium SSD v2")),
    ("ADR-002-premium-ssd-v2-decoupled-storage.md", "ADR-002: Premium SSD v2", ("ADR-001-constrained-vcpu-for-sql-workloads.md", "ADR-001: Constrained vCPU"), ("ADR-003-expressroute-metered-vs-unlimited.md", "ADR-003: ExpressRoute Plan")),
    ("ADR-003-expressroute-metered-vs-unlimited.md", "ADR-003: ExpressRoute Plan", ("ADR-002-premium-ssd-v2-decoupled-storage.md", "ADR-002: Premium SSD v2"), ("ADR-004-service-endpoints-vs-private-endpoints.md", "ADR-004: Service Endpoints")),
    ("ADR-004-service-endpoints-vs-private-endpoints.md", "ADR-004: Service Endpoints", ("ADR-003-expressroute-metered-vs-unlimited.md", "ADR-003: ExpressRoute Plan"), ("ADR-005-ama-dcr-edge-log-filtering.md", "ADR-005: AMA DCR Filtering")),
    ("ADR-005-ama-dcr-edge-log-filtering.md", "ADR-005: AMA DCR Filtering", ("ADR-004-service-endpoints-vs-private-endpoints.md", "ADR-004: Service Endpoints"), ("../math-models/README.md", "Mathematical Models")),
]

MATH_MODELS = [
    ("expressroute-breakeven.md", "ExpressRoute Break-Even", None, ("firewall-sku-crossover.md", "Firewall SKU Crossover")),
    ("firewall-sku-crossover.md", "Firewall SKU Crossover", ("expressroute-breakeven.md", "ExpressRoute Break-Even"), ("sql-licensing-ccc-matrix.md", "SQL Licensing CCC Matrix")),
    ("sql-licensing-ccc-matrix.md", "SQL Licensing CCC Matrix", ("firewall-sku-crossover.md", "Firewall SKU Crossover"), ("../README.md", "Documentation Portal")),
]

def update_file(filepath, header_nav, footer_nav):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Strip any previously inserted navigation header
    lines = content.split('\n')
    cleaned_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if i < 8 and (line.startswith('> 🧭 **Navigation**') or line.startswith('> 🧭 **Navegación**')):
            i += 1
            continue
        cleaned_lines.append(line)
        i += 1

    content = '\n'.join(cleaned_lines).strip()

    # Strip existing footer if present
    if '\n## 🧭 Navigation' in content:
        content = content.split('\n## 🧭 Navigation')[0].strip()
        if content.endswith('---'):
            content = content[:-3].strip()
    elif '\n## 🧭 Navegación' in content:
        content = content.split('\n## 🧭 Navegación')[0].strip()
        if content.endswith('---'):
            content = content[:-3].strip()

    c_lines = content.split('\n')
    if c_lines[0].startswith('# '):
        title = c_lines[0]
        body = '\n'.join(c_lines[1:]).strip()
        final_content = f"{title}\n\n{header_nav}\n\n{body}\n\n{footer_nav}\n"
    else:
        final_content = f"{header_nav}\n\n{content}\n\n{footer_nav}\n"

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(final_content)
    print(f"Updated {os.path.basename(filepath)}")

# 1. Update Guides
for filename, title, prev_item, next_item in GUIDES:
    filepath = os.path.join(DOCS_DIR, filename)
    nav_links = ["[🏠 Framework Root](../README.md)", "[📚 Documentation Index](README.md)"]
    if prev_item:
        nav_links.append(f"[⬅️ Previous: {prev_item[1]}]({prev_item[0]})")
    if next_item:
        nav_links.append(f"[➡️ Next: {next_item[1]}]({next_item[0]})")

    header = f"> 🧭 **Navigation**: {' | '.join(nav_links)}"
    
    prev_cell = f"[⬅️ Previous: {prev_item[1]}]({prev_item[0]})" if prev_item else "[🏠 Framework Root](../README.md)"
    next_cell = f"[➡️ Next: {next_item[1]}]({next_item[0]})" if next_item else "[📜 ADR Index](adr/README.md)"
    
    footer = f"""---

## 🧭 Navigation & Reading Path

| {prev_cell} | [📚 Documentation Index](README.md) | {next_cell} |
| :--- | :---: | ---: |
| [🏠 Return to Framework Root](../README.md) | **[Interactive Docs Directory](README.md)** | [Next Thematic Module ➡️]({next_item[0] if next_item else 'adr/README.md'}) |
"""
    update_file(filepath, header, footer)

# 2. Update ADRs
for filename, title, prev_item, next_item in ADRS:
    filepath = os.path.join(DOCS_DIR, 'adr', filename)
    nav_links = ["[🏠 Framework Root](../../README.md)", "[📚 Documentation Index](../README.md)", "[📜 All ADRs](README.md)"]
    if prev_item:
        nav_links.append(f"[⬅️ Previous: {prev_item[1]}]({prev_item[0]})")
    if next_item:
        nav_links.append(f"[➡️ Next: {next_item[1]}]({next_item[0]})")

    header = f"> 🧭 **Navigation**: {' | '.join(nav_links)}"
    prev_cell = f"[⬅️ Previous: {prev_item[1]}]({prev_item[0]})" if prev_item else "[📜 All ADRs (Index)](README.md)"
    next_cell = f"[➡️ Next: {next_item[1]}]({next_item[0]})" if next_item else "[📐 Math Models](../math-models/README.md)"

    footer = f"""---

## 🧭 Navigation

| {prev_cell} | [📜 All ADRs (Index)](README.md) | {next_cell} |
| :--- | :---: | ---: |
| [📚 Documentation Index](../README.md) | [🏠 Framework Root](../../README.md) | [Next Architectural Decision ➡️]({next_item[0] if next_item else 'README.md'}) |
"""
    update_file(filepath, header, footer)

# 3. Update Math Models
for filename, title, prev_item, next_item in MATH_MODELS:
    filepath = os.path.join(DOCS_DIR, 'math-models', filename)
    nav_links = ["[🏠 Framework Root](../../README.md)", "[📚 Documentation Index](../README.md)", "[📐 Math Models Index](README.md)"]
    if prev_item:
        nav_links.append(f"[⬅️ Previous: {prev_item[1]}]({prev_item[0]})")
    if next_item:
        nav_links.append(f"[➡️ Next: {next_item[1]}]({next_item[0]})")

    header = f"> 🧭 **Navigation**: {' | '.join(nav_links)}"
    prev_cell = f"[⬅️ Previous: {prev_item[1]}]({prev_item[0]})" if prev_item else "[📐 Math Models Index](README.md)"
    next_cell = f"[➡️ Next: {next_item[1]}]({next_item[0]})" if next_item else "[📚 Documentation Index](../README.md)"

    footer = f"""---

## 🧭 Navigation

| {prev_cell} | [📐 Math Models Index](README.md) | {next_cell} |
| :--- | :---: | ---: |
| [📚 Documentation Index](../README.md) | [🏠 Framework Root](../../README.md) | [Next Mathematical Model ➡️]({next_item[0] if next_item else 'README.md'}) |
"""
    update_file(filepath, header, footer)

# 4. Update Monographs
es_path = os.path.join(DOCS_DIR, "informe-exhaustivo-finops-azure-iaas-es.md")
with open(es_path, 'r', encoding='utf-8') as f:
    es_c = f.read()

# Strip any existing nav
if '\n## 🧭 Navegación' in es_c:
    es_c = es_c.split('\n## 🧭 Navegación')[0].strip()
    if es_c.endswith('---'):
        es_c = es_c[:-3].strip()

es_lines = [l for i, l in enumerate(es_c.split('\n')) if not (i < 8 and l.startswith('> 🧭 **Navegación**'))]
es_c = '\n'.join(es_lines).strip()
parts = es_c.split('\n', 1)
es_header = "> 🧭 **Navegación**: [🏠 Inicio del Repositorio](../README.md) | [📚 Portal de Documentación](README.md) | 🇬🇧 **[Read English Translation](comprehensive-finops-azure-iaas-report-en.md)** | [➡️ Guía 01: Gobernanza y Etiquetas](01-governance-tagging-cost-allocation.md)"
es_footer = """---

## 🧭 Navegación y Guías de Implementación

| [🏠 Inicio del Repositorio](../README.md) | [📚 Portal de Documentación](README.md) | [➡️ Guía 01: Gobernanza](01-governance-tagging-cost-allocation.md) |
| :--- | :---: | ---: |
| 🇪🇸 **Texto Íntegro Original** | [Directorio de Modelos](math-models/README.md) | 🇬🇧 [English Translation](comprehensive-finops-azure-iaas-report-en.md) |
"""
with open(es_path, 'w', encoding='utf-8') as f:
    f.write(f"{parts[0]}\n\n{es_header}\n\n{parts[1].strip()}\n\n{es_footer}\n")
print("Updated informe-exhaustivo-finops-azure-iaas-es.md")

en_path = os.path.join(DOCS_DIR, "comprehensive-finops-azure-iaas-report-en.md")
with open(en_path, 'r', encoding='utf-8') as f:
    en_c = f.read()

if '\n## 🧭 Navigation' in en_c:
    en_c = en_c.split('\n## 🧭 Navigation')[0].strip()
    if en_c.endswith('---'):
        en_c = en_c[:-3].strip()

en_lines = [l for i, l in enumerate(en_c.split('\n')) if not (i < 8 and l.startswith('> 🧭 **Navigation**'))]
en_c = '\n'.join(en_lines).strip()
parts = en_c.split('\n', 1)
en_header = "> 🧭 **Navigation**: [🏠 Framework Root](../README.md) | [📚 Documentation Index](README.md) | 🇪🇸 **[Versión Original en Español](informe-exhaustivo-finops-azure-iaas-es.md)** | [➡️ Guide 01: Governance & Tagging](01-governance-tagging-cost-allocation.md)"
en_footer = """---

## 🧭 Navigation & Implementation Guides

| [🏠 Framework Root](../README.md) | [📚 Documentation Index](README.md) | [➡️ Guide 01: Governance](01-governance-tagging-cost-allocation.md) |
| :--- | :---: | ---: |
| 🇬🇧 **Full English Translation** | [Math Models Index](math-models/README.md) | 🇪🇸 [Original Spanish Monograph](informe-exhaustivo-finops-azure-iaas-es.md) |
"""
with open(en_path, 'w', encoding='utf-8') as f:
    f.write(f"{parts[0]}\n\n{en_header}\n\n{parts[1].strip()}\n\n{en_footer}\n")
print("Updated comprehensive-finops-azure-iaas-report-en.md")
