// Initialize tooltips
const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))


// Change menu icon
document.querySelectorAll('.bi-layout-text-sidebar-reverse').forEach(element => {
  element.classList.remove('bi-layout-text-sidebar-reverse');
  element.classList.add('bi-list');
});


// Placeholder in search bar
document.addEventListener("DOMContentLoaded", function() {
  var inputElement = document.querySelector(".aa-Input");
  if (inputElement) {
    inputElement.placeholder = "Search";
  }
});


// Update the ellipsis link when quotes are expanded
document.addEventListener('DOMContentLoaded', function() {
  // Listen for click events on the document
  document.body.addEventListener('click', function(event) {
    // Check if the clicked element is a link inside a blockquote
    if (event.target.closest('blockquote') && event.target.matches('blockquote a')) {
      const link = event.target;
      if (link.textContent === '(Show less)') {
        link.textContent = '...';
      } else {
        link.textContent = '(Show less)';
      }
    }
  });
});

// Add translate buttons to quotes
document.addEventListener('DOMContentLoaded', function() {
  const blockquotes = document.querySelectorAll('blockquote');

  blockquotes.forEach(blockquote => {
    const quoteOrig = blockquote.querySelector('.quote-orig');
    const quoteModern = blockquote.querySelector('.quote-modern');

    // Create and append the .show-modern link to .quote-orig
    const showModernLink = document.createElement('a');
    showModernLink.className = 'show-modern';
    showModernLink.innerHTML = '<i class="bi bi-translate"></i>';
    showModernLink.setAttribute('data-bs-toggle', 'tooltip');
    showModernLink.setAttribute('data-bs-title', 'Modern translation');
    quoteOrig.appendChild(showModernLink);

    // Create and append the .show-orig link to .quote-modern
    const showOrigLink = document.createElement('a');
    showOrigLink.className = 'show-orig';
    showOrigLink.innerHTML = '<i class="bi bi-arrow-return-left"></i>';
    showOrigLink.setAttribute('data-bs-toggle', 'tooltip');
    showOrigLink.setAttribute('data-bs-title', 'Original quote');
    quoteModern.appendChild(showOrigLink);
  });

  // The rest of the event delegation code remains the same
  document.body.addEventListener('click', function(event) {
    const target = event.target;

    const showOrigLink = target.closest('.show-orig');
    const showModernLink = target.closest('.show-modern');

    if (showOrigLink || showModernLink) {
      event.preventDefault();

      const blockquoteElem = target.closest('blockquote');
      const quoteOrig = blockquoteElem.querySelector('.quote-orig');
      const quoteModern = blockquoteElem.querySelector('.quote-modern');

      if (showOrigLink) {
        quoteOrig.style.display = 'block';
        quoteModern.style.display = 'none';
      } else if (showModernLink) {
        quoteOrig.style.display = 'none';
        quoteModern.style.display = 'block';
      }
    }
  });
});


// Switch between original and modern translations of quotes
document.addEventListener('DOMContentLoaded', function() {
  document.body.addEventListener('click', function(event) {
    const target = event.target;

    // Check if the clicked element is .show-orig or .show-modern link
    const showOrigLink = target.closest('.show-orig');
    const showModernLink = target.closest('.show-modern');

    if (showOrigLink || showModernLink) {
      event.preventDefault(); // Prevent any default link behavior

      const blockquoteElem = target.closest('blockquote');
      const quoteOrig = blockquoteElem.querySelector('.quote-orig');
      const quoteModern = blockquoteElem.querySelector('.quote-modern');

      if (showOrigLink) {
        // Show .quote-orig and hide .quote-modern
        quoteOrig.style.display = 'block';
        quoteModern.style.display = 'none';
      } else if (showModernLink) {
        // Show .quote-modern and hide .quote-orig
        quoteOrig.style.display = 'none';
        quoteModern.style.display = 'block';
        }
      }
  });
});