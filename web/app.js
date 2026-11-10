const app = document.getElementById('app');
const vehicleList = document.getElementById('vehicles');
const fieldsEl = document.getElementById('fields');
let vehicles = [];
let fields = [];
let overrides = {};
let selected = null;
let debounce;
let dirty = {};

function nui(name, data = {}) {
  return fetch(`https://${GetParentResourceName()}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(data) }).then(response => response.json());
}
function showToast(message, success = true) {
  const toast = document.getElementById('toast');
  toast.textContent = message;
  toast.className = `toast show${success ? '' : ' error'}`;
  clearTimeout(showToast.timer);
  showToast.timer = setTimeout(() => { toast.className = 'toast'; }, 2600);
}
function renderVehicles() {
  const query = document.getElementById('search').value.trim().toLowerCase();
  const filtered = vehicles.filter(v => v.label.toLowerCase().includes(query) || v.model.includes(query));
  document.getElementById('vehicle-count').textContent = `${filtered.length.toLocaleString()} models`;
  vehicleList.replaceChildren();
  for (const vehicle of filtered) {
    const row = document.createElement('button');
    row.className = `vehicle-row${selected?.model === vehicle.model ? ' selected' : ''}`;
    const title = document.createElement('strong');
    title.textContent = vehicle.label;
    const model = document.createElement('small');
    model.textContent = vehicle.model;
    row.append(title, model);
    row.addEventListener('click', () => selectVehicle(vehicle));
    vehicleList.append(row);
  }
}
function selectVehicle(vehicle) {
  selected = vehicle;
  dirty = {};
  clearTimeout(debounce);
  document.getElementById('empty').classList.add('hidden');
  document.getElementById('editor').classList.remove('hidden');
  document.getElementById('vehicle-model').textContent = vehicle.model.toUpperCase();
  document.getElementById('vehicle-label').textContent = vehicle.label;
  document.getElementById('saved-badge').textContent = overrides[vehicle.model] ? 'SERVER OVERRIDE' : 'DEFAULT';
  document.getElementById('saved-badge').classList.toggle('saved', Boolean(overrides[vehicle.model]));
  const values = overrides[vehicle.model] || {};
  fieldsEl.replaceChildren();
  for (const field of fields) {
    const row = document.createElement('div'); row.className = 'field';
    const top = document.createElement('div'); top.className = 'field-top';
    const label = document.createElement('label'); label.textContent = `${field.label}${field.unit ? ` (${field.unit})` : ''}`;
    const output = document.createElement('output');
    const input = document.createElement('input'); input.type = 'range'; input.min = field.min; input.max = field.max; input.step = field.step; input.value = values[field.key] ?? midpoint(field);
    const format = value => Number(value).toFixed(field.step < 1 ? (String(field.step).split('.')[1] || '').length : 0);
    output.textContent = format(input.value);
    input.addEventListener('input', () => {
      output.textContent = format(input.value);
      dirty[field.key] = Number(input.value);
      nui('preview', { settings: { [field.key]: Number(input.value) } });
      clearTimeout(debounce);
      debounce = setTimeout(flushChanges, 650);
    });
    top.append(label, output); row.append(top, input); fieldsEl.append(row);
  }
  renderVehicles();
}
function midpoint(field) { return field.min + (field.max - field.min) / 2; }
function flushChanges() {
  if (!selected || Object.keys(dirty).length === 0) return;
  const model = selected.model;
  const settings = { ...dirty };
  dirty = {};
  nui('save', { model, settings }).catch(() => showToast('Could not save changes.', false));
}
window.addEventListener('message', async event => {
  const data = event.data;
  if (data.action === 'open') {
    app.classList.remove('hidden');
    const response = await nui('getVehicles');
    vehicles = response.vehicles || []; fields = response.fields || []; overrides = response.overrides || {};
    renderVehicles();
  }
  if (data.action === 'sync') {
    overrides = data.overrides || {};
    renderVehicles();
    if (selected) selectVehicle(selected);
  }
  if (data.action === 'toast') showToast(data.message, data.success);
});
document.getElementById('search').addEventListener('input', renderVehicles);
document.getElementById('close').addEventListener('click', () => { flushChanges(); app.classList.add('hidden'); nui('close'); });
document.getElementById('save').addEventListener('click', () => flushChanges());
document.getElementById('reset').addEventListener('click', () => selected && nui('reset', { model: selected.model }));
document.addEventListener('keydown', event => { if (event.key === 'Escape' && !app.classList.contains('hidden')) { flushChanges(); app.classList.add('hidden'); nui('close'); } });
